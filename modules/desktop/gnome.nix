{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs.gnome; [
    nautilus gnome-tweaks gnome-software gnome-disk-utility
    gnome-calculator gnome-system-monitor gnome-screenshot
  ];

}
