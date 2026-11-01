{ inputs, lib, pkgs, ... }:

{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  # SilentSDDM: themed SDDM login screen (built-in theme, no custom wallpaper)
  programs.silentSDDM = {
    enable = true;
    theme = "catppuccin-mocha";

    # System font (the theme ships RedHatDisplay) and bigger text: the stock
    # sizes are tiny at 1080p. `General/scale` multiplies everything, so the
    # size bumps below are moderate on purpose.
    settings = {
      "General".scale = 1.1;

      "LockScreen.Clock" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 90; };
      "LockScreen.Date" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 18; };
      "LockScreen.Message" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 16; };

      "LoginScreen.LoginArea.Username" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 22; };
      "LoginScreen.LoginArea.PasswordInput" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 16; };
      "LoginScreen.LoginArea.LoginButton" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 16; };
      "LoginScreen.LoginArea.Spinner" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 18; };
      "LoginScreen.LoginArea.WarningMessage" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 15; };

      "LoginScreen.MenuArea.Buttons" = { "font-family" = "CaskaydiaCove Nerd Font"; };
      "LoginScreen.MenuArea.Popups" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 15; };
      "LoginScreen.MenuArea.Session" = { "font-size" = 14; };
      "LoginScreen.MenuArea.Layout" = { "font-size" = 14; };

      "Tooltips" = { "font-family" = "CaskaydiaCove Nerd Font"; "font-size" = 15; };
    };
  };

  services.displayManager = {
    # SDDM itself runs as a Wayland greeter, on weston (no KDE/kwin needed)
    sddm.wayland = {
      enable = lib.mkForce true;
      compositor = lib.mkForce "weston";
    };
    defaultSession = "niri";
    # Same cursor as the desktop (home.pointerCursor) on the login screen
    sddm.settings.Theme = {
      CursorTheme = "Bibata-Modern-Classic";
      CursorSize = 24;
    };
  };

  environment.systemPackages = [ pkgs.bibata-cursors ];
}
