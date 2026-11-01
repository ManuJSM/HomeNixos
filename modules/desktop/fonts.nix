{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.caskaydia-cove   # Cascadia Code with icon glyphs ("CaskaydiaCove Nerd Font"): default monospace
      nerd-fonts.jetbrains-mono   # JetBrains Mono with icon glyphs (fallback)
      noto-fonts                  # wide Unicode coverage
      noto-fonts-color-emoji      # colour emoji
      material-symbols            # icon font used by DMS
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "CaskaydiaCove Nerd Font" "JetBrainsMono Nerd Font" "Noto Mono" "DejaVu Sans Mono" ];
        sansSerif = [ "CaskaydiaCove Nerd Font" "Noto Sans" "DejaVu Sans" ];
        serif = [ "Noto Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
