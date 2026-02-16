{ config, pkgs, lib, ... }:

let
  # Funkcija koja generiše title sa datumom
  nixosTitle = name: 
    let
      now = builtins.substring 0 10 (builtins.toString (builtins.localTime));
    in
      "${name} ${now}";
in
{
  # Uvoz modula
  imports = [
    ./modules/common.nix
    ./modules/desktop/plasma.nix
    ./hardware-configuration.nix
  ];

  # Osnovna konfiguracija
  networking.hostName = "nixos";
  time.timeZone = "Europe/Belgrade";
  
  boot.kernelPackages = pkgs.linuxPackages_latest;  

  # Isključi konfliktni servis
services.power-profiles-daemon.enable = false;

services.tlp = {
  enable = true;
  settings = {
    # 1. STOP TURBO BOOST (Za tvojih 4.6GHz skokova)
    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_AC = 0;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;

    # 2. INTEL P-STATE (Limitiranje maksimalne frekvencije)
    # i5-1334U ima osnovni takt oko 1.3GHz.
    # Sa 70% limitom, on će raditi stabilno i hladno.
    CPU_MAX_PERF_ON_AC = 81;
    CPU_MAX_PERF_ON_BAT = 60;

    # 3. ENERGY PERFORMANCE PREFERENCE (EPP)
    # Ovo je najbitnije za Intel 13. gen "U" seriju.
    # 'power' tera procesor da favorizuje 8 E-jezgara umesto 2 P-jezgra.
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    # 4. TERMALNI MENADŽMENT
    # Sprečava nagle skokove temperature koji pale ventilator.
    PLATFORM_PROFILE_ON_AC = "balanced";
    PLATFORM_PROFILE_ON_BAT = "low-power";
  };
};

  #Fish shellALiases

  programs.fish = {
    enable = true;
    shellAliases = {
      # Brzi rebuild sistema
      sys-up = "doas nixos-rebuild switch --flake .#nixos";

      # Čišćenje sistema (starije od 30 dana + optimizacija)
      sys-clean = "doas nix-collect-garbage --delete-older-than 30d && doas nix-store --optimise";

      # USBGuard prečice
      usb-list = "doas usbguard list-devices";
      usb-allow = "doas usbguard allow-device"; # koristiš kao: usb-allow <ID> -p

      # Brzi uvid u stanje sistema
      fetch = "fastfetch";
      gens = "nixos-rebuild list-generations";
    };
  };


  # Home Manager korisnik konfiguracija
  home-manager.users.lxd = import ./home.nix;
  
  nixpkgs.config.allowUnfree = true;

  # Paketi
  environment.systemPackages = with pkgs; [
    fastfetch
    figlet
    kdePackages.kpmcore
    vscode
    flatpak
    tlp
  ];

  # Enable Doas
 security.doas.enable = true;
  # Disable Sudo
 security.sudo.enable = false;

  # Pravila ko sme da postane "admin"
 security.doas.extraRules = [{
   users = [ "lxd" ]; # Username
   keepEnv = true;  # Zadržava putanje i podešavanja (npr. boju terminala)
   persist = true;  # Pamti lozinku par minuta da ne mora stalno da se kuca
 }];

  #OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;      # Zabranjuje lozinke
      KbdInteractiveAuthentication = false; # Zabranjuje interaktivne upite
      PermitRootLogin = "no";             # Zabranjuje root-u da se kači spolja
    };
  };

  #Dodavanje tvog javnog ključa korisniku
  users.users.lxd = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Da bi mogao koristiti doas/sudo
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..." # OVDE ZALEPI SADRŽAJ .pub FAJLA
    ];
    shell = pkgs.fish;
  };

  #Privatnost DNS upita (DNS over TLS)
  services.resolved = {
   enable = true;
   dnssec = "true";
   domains = [ "~." ]; # Koristi ove DNS servere za sve domene
   fallbackDns = [ "1.1.1.1" "9.9.9.9" ];
 };
  # Govorimo sistemu da koristi lokalni resolver koji je prethodno podešen
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  #Flatpak
  services.flatpak.enable = true;

  # Firejail konfiguracija - Sandboxing aplikacija
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      # Firefox
      firefox = {
        executable = "${pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };

      # Telegram sa dodatnim dozvolama za folder Preuzimanja
      telegram-desktop = {
        executable = "${pkgs.telegram-desktop}/bin/telegram-desktop";
        profile = "${pkgs.firejail}/etc/firejail/telegram-desktop.profile";
        extraArgs = [ "--whitelist=~/Downloads" ];
      };
    };
  };

  #Firewall
  networking.firewall = {
  enable = true;
  # Dozvoljavaš TCP portove (npr. 80 za HTTP, 443 za HTTPS)
  allowedTCPPorts = [ 22 80 443 ];
  # Dozvoljavaš UDP portove (npr. za igrice ili specifične servise)
  allowedUDPPorts = [ 51820 ]; # Primer za Wireguard VPN
 };

  #USBGuard
  services.usbguard = {
  enable = true;
  # Bokira sve nove uređaje
  presentDevicePolicy = "apply-policy";
  # NixOS će dozvoliti uređaje koji su već uštekani tokom boot-a
  # tako da ne ostaneš bez tastature odmah.
  implicitPolicyTarget = "block";
};

  # Bootloader sa automatskim title sa datumom
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Optimizacija sistema (Garbage Collection - preporučujem da dodaš i ovo)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

  # Verzija sistema
  system.stateVersion = "25.11";
}

