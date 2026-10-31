{ inputs, ... }:

{
  imports = [
    inputs.dms.homeModules.default   # DankMaterialShell home-manager module
    inputs.dms.homeModules.niri      # DMS <-> niri integration (includes, optional keybinds)
  ];

  # DMS (DankMaterialShell): bar, launcher/spotlight, notifications, lock screen,
  # wallpaper, clipboard manager, power menu. Colours come from matugen (wallpaper).
  # Its own settings stay GUI-managed (Mod+Comma opens DMS settings).
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;   # start DMS as a user service with the graphical session

    niri = {
      # niri keybinds are defined by hand in ./niri.nix, not by DMS
      enableKeybinds = false;
      enableSpawn = false;
      # DMS writes ~/.config/niri/dms/*.kdl (colours, cursor) and niri-flake's
      # config is wrapped to include them. Binds/layout/outputs stay ours.
      includes.filesToInclude = [ "colors" "cursor" "wpblur" ];
    };
  };
}
