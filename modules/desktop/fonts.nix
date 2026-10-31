{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono   # JetBrains Mono with icon glyphs (terminal, DMS)
      noto-fonts                  # wide Unicode coverage
      noto-fonts-color-emoji      # colour emoji
      material-symbols            # icon font used by DMS
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Mono" "DejaVu Sans Mono" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        serif = [ "Noto Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
