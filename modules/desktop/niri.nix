{ inputs, pkgs, ... }:

{
  imports = [ inputs.niri-flake.nixosModules.niri ];

  # niri binary cache (niri is built from source otherwise)
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # niri: scrollable-tiling Wayland compositor. The niri-flake module also sets
  # up xdg-desktop-portal-gnome (screen capture via PipeWire for OBS/browsers),
  # polkit agent and gnome-keyring. Its settings live in home/desktop/niri.nix.
  programs.niri.enable = true;

  services.displayManager.defaultSession = "niri";

  # Portal config: niri uses the GNOME portal for screencast, GTK for file dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
    config.niri = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.OpenURI" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Print" = "gtk";
    };
  };

  # uinput: lets the auto-clicker script create a virtual mouse (group "uinput")
  hardware.uinput.enable = true;
  users.users.shirok.extraGroups = [ "uinput" "video" ];

  # Wayland-clipboard/notification helpers used by niri binds and DMS
  environment.systemPackages = with pkgs; [
    wl-clipboard   # wl-copy / wl-paste (also used by helix clipboard yanks)
    libnotify      # notify-send
  ];

  # dconf: GTK/GNOME settings backend (needed by GTK apps and stylix)
  programs.dconf.enable = true;
}
