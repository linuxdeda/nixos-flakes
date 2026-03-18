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
    ./modules/services.nix
    ./modules/desktop/plasma.nix
    ./hardware-configuration.nix
  ];

  # Osnovna konfiguracija
  networking.hostName = "nixos";
  time.timeZone = "Europe/Belgrade";
  
  boot.kernelPackages = pkgs.linuxPackages_latest;  

  # Home Manager korisnik konfiguracija
  home-manager.users.lxd = import ./home.nix;
  
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  # Paketi
  environment.systemPackages = with pkgs; [
    fastfetch
    figlet
    vscode
    flatpak
    tlp
    keepassxc
    syncthing
    openvpn
    (python3.withPackages (ps: [ ps.pip ]))
  ];

  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];

  #Firefox keepass servis
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.keepassxc ];
  };

  # Pravila ko sme da postane "admin"
 security.doas.extraRules = [{
   users = [ "lxd" ]; # Username
   keepEnv = true;  # Zadržava putanje i podešavanja (npr. boju terminala)
   persist = true;  # Pamti lozinku par minuta da ne mora stalno da se kuca
 }];

  #Dodavanje tvog javnog ključa korisniku
  users.users.lxd = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Da bi mogao koristiti doas/sudo
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1l*-**/*--........email.com" # OVDE ZALEPI SADRŽAJ .pub FAJLA
    ];
    shell = pkgs.fish;
  };


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

  # Firewall
  networking.firewall = {
  enable = true;
  # TCP 22000 je za prenos podataka (Syncthing)
  allowedTCPPorts = [ 22 80 443 22000 ];
  # UDP 22000 (podaci) i 21027 (lokalno otkrivanje uređaja)
  allowedUDPPorts = [ 51820 22000 21027 ];
  
  #Otvaranje portova za Chrome Cast # (1)
  extraCommands = ''
    iptables -A nixos-fw -p udp -d 224.0.0.0/4 -j nixos-fw-accept
    iptables -A nixos-fw -p udp -s 224.0.0.0/4 -j nixos-fw-accept
  '';
  allowedUDPPortRanges = [{ from = 32768; to = 60999; }];

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

