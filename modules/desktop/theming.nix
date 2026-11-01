# GTK/Qt app theming.
#
# DMS (matugen) only writes the colour files: ~/.config/gtk-{3,4}.0/dank-colors.css
# and ~/.config/qt{5,6}ct/colors/matugen.conf. For apps to actually use them you
# also need a real GTK theme and a Qt platform theme:
#   - adw-gtk3: DMS selects "adw-gtk3-dark" for GTK3 (and Electron file dialogs
#     such as VSCodium's). Without it GTK3 falls back to light Adwaita.
#   - qt6ct: platform theme for Qt apps (Okular, ...). Needs
#     QT_QPA_PLATFORMTHEME=qt6ct or they run with the default light palette.
#
# After a rebuild, apply the colours once from DMS: Settings -> Theme ->
# "Apply GTK colors" / "Apply Qt colors" (or run its scripts/gtk.sh + qt.sh).
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3             # GTK3 theme DMS patches with the wallpaper colours
    qt6Packages.qt6ct    # Qt platform theme (Qt6: Okular, ...)
  ];

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
}
