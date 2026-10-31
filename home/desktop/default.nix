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
  ];

  # Stylix (themed via modules/desktop/stylix.nix): leave these apps to the user's own configs
  stylix.targets = {
    kitty.enable = false;    # kitty.conf is ported 1:1 from the user's config
    helix.enable = false;    # helix uses the kanagawa_transparent theme
    firefox.enable = false;  # no profile theming
  };

  home.packages = with pkgs; [
    playerctl   # playerctl: control media players (play/pause/next) from the shell / keybinds
    (callPackage ./scripts/autoclicker.nix { })   # auto-clicker (see scripts/autoclicker.nix)
    claude-code # claude-code: Anthropic's AI coding agent for the terminal (`claude`)
    opencode    # opencode: open-source AI coding agent for the terminal (`opencode`)
    nautilus    # nautilus: GNOME graphical file manager (default for folders)
    nodejs      # nodejs: JavaScript runtime (node, npm, npx) - current LTS
    bun         # bun: fast JavaScript runtime, bundler and package manager
    vscodium    # vscodium: VS Code without Microsoft telemetry/branding (`codium`)
    windsurf    # windsurf: AI code editor (VS Code fork by Codeium)
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
