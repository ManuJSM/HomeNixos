# portatil: Intel laptop (niri + DMS + laptop power management).
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/laptop
  ];

  networking = {
    hostName = "portatil";
    networkmanager.enable = true;   # NetworkManager (DMS has a network applet)
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";
}
