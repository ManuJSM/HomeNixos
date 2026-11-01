# Desktop user environment (sobremesa, portatil). Added on top of home/common.nix.
{ pkgs, ... }:

{
  imports = [
    ./niri.nix
    ./dms.nix
    ./kitty.nix
    ./helix.nix
    ./superfile.nix
    ./aria2.nix
    ./browsers.nix
    ./mpv.nix
    ./ides.nix
  ];

  # No stylix: DMS/matugen themes GTK/Qt/niri from the wallpaper and needs those
  # files writable. Only the cursor and the dark preference are set here.
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";                         # DMS theme for GTK3 apps
    font-name = "CaskaydiaCove Nerd Font 13";            # GTK UI font (Nautilus, dialogs)
    monospace-font-name = "CaskaydiaCove Nerd Font 13";
  };

  home.packages = with pkgs; [
    playerctl   # playerctl: control media players (play/pause/next) from the shell / keybinds
    (callPackage ./scripts/autoclicker.nix { })   # auto-clicker (see scripts/autoclicker.nix)
    claude-code # claude-code: Anthropic's AI coding agent for the terminal (`claude`)
    opencode    # opencode: open-source AI coding agent for the terminal (`opencode`)
    nautilus    # nautilus: GNOME graphical file manager (default for folders)
    nodejs      # nodejs: JavaScript runtime (node, npm, npx) - current LTS
    bun         # bun: fast JavaScript runtime, bundler and package manager
    beekeeper-studio  # beekeeper-studio: SQL database GUI (MySQL, Postgres, SQLite...)
    libreoffice # libreoffice: office suite (Writer, Calc, Impress) - "still" stable branch
    kdePackages.okular  # okular: PDF/document viewer (annotate, fill forms, sign) - Foxit replacement
  ];

  # Open folders with Nautilus by default (xdg-open, browsers "show in folder", etc.)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];  # open PDFs with Okular
    };
  };
}
