{ inputs, lib, ... }:

{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  # SilentSDDM: themed SDDM login screen (built-in theme, no custom wallpaper)
  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };

  services.displayManager = {
    # SDDM itself runs as a Wayland greeter, on weston (no KDE/kwin needed)
    sddm.wayland = {
      enable = lib.mkForce true;
      compositor = lib.mkForce "weston";
    };
    defaultSession = "niri";
  };
}
