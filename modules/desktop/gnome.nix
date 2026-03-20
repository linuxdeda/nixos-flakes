{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    nautilus
    gnome-tweaks
    gnome-software
    gnome-disk-utility
    gnome-calculator
    gnome-system-monitor
    gnome-screenshot
    gnome-shell
    gnomeExtensions.appindicator
    gnome-clocks
    gnomeExtensions.arcmenu
    evince
    eog
    youtube-music
  ];

}
