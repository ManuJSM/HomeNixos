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

  # GitHub account, so this must not go in home/common.nix.
  home-manager.users.shirok.programs.git = {
    enable = true;
    settings.user = {
      name = "ManuJSM";
      email = "ManuJSM@users.noreply.github.com";
    };
  };

  system.stateVersion = "26.05";
}
