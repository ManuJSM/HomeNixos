# sobremesa: AMD desktop (niri + DMS).
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common
    ../../modules/desktop
  ];

  networking = {
    hostName = "sobremesa";
    networkmanager.enable = true;   # NetworkManager (DMS has a network applet)
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";
}
