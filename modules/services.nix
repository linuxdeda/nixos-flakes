{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  networking.networkmanager.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # Isključi konfliktni servis
  services.power-profiles-daemon.enable = false;

  # Važno za komunikaciju sa hardverom/browserom
  services.pcscd.enable = true;
  # Enable Doas
  security.doas.enable = true;
  # Disable Sudo
  security.sudo.enable = false;
  # Flatpak
  services.flatpak.enable = true;
  # (1)
  services.avahi.enable = true;

services.tlp = {
  enable = true;
  settings = {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 1;
    CPU_HWP_DYN_BOOST_ON_AC = 0;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;
    CPU_SCALING_MAX_FREQ_ON_AC = 3200000;
    CPU_SCALING_MAX_FREQ_ON_BAT = 2200000;
    CPU_SCALING_MIN_FREQ_ON_AC = 400000;
    CPU_SCALING_MIN_FREQ_ON_BAT = 400000;
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    CPU_MIN_PERF_ON_AC = 10;
    CPU_MIN_PERF_ON_BAT = 20;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MAX_PERF_ON_BAT = 60;
    PLATFORM_PROFILE_ON_AC = "balanced";
    PLATFORM_PROFILE_ON_BAT = "quiet";
    START_CHARGE_THRESH_BAT0 = 70;
    STOP_CHARGE_THRESH_BAT0 = 80;
    DISK_APM_LEVEL_ON_AC = "254 254";
  };
};


  #OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;      # Zabranjuje lozinke
      KbdInteractiveAuthentication = false; # Zabranjuje interaktivne upite
      PermitRootLogin = "no";             # Zabranjuje root-u da se kači spolja
    };
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

   #Privatnost DNS upita (DNS over TLS)
  services.resolved = {
   enable = true;
   dnssec = "true";
   domains = [ "~." ]; # Koristi ove DNS servere za sve domene
   fallbackDns = [ "1.1.1.1" "9.9.9.9" ];
 };
  # Govorimo sistemu da koristi lokalni resolver koji je prethodno podešen
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  #Podešavanje syncthing servisa
  services.syncthing = {
    enable = true;
    user = "lxd"; # Obavezno stavi svoj username ovde
    dataDir = "/home/lxd/Documents";
    configDir = "/home/lxd/.config/syncthing";
};

}
