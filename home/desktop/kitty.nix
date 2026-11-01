{ ... }:

{
  # kitty: GPU-accelerated terminal emulator
  # Ported from ~/.config/kitty/kitty.conf with its includes inlined.
  programs.kitty = {
    enable = true;
    extraConfig = ''
      #    __ ___ __  __
      #   / //_(_) /_/ /___ __
      #  / ,< / / __/ __/ // /
      # /_/|_/_/\__/\__/\_, /
      #                /___/
      #
      # Configuration
      font_family                 CaskaydiaCove Nerd Font
      font_size                   14
      bold_font                   auto
      italic_font                 auto
      bold_italic_font            auto
      remember_window_size        no
      initial_window_width        950
      initial_window_height       500
      cursor_blink_interval       0.5
      cursor_stop_blinking_after  1
      scrollback_lines            2000
      wheel_scroll_min_lines      1
      enable_audio_bell           no
      window_padding_width        10
      hide_window_decorations     yes
      background_opacity          0.7
      dynamic_background_opacity  yes
      confirm_os_window_close     0
      selection_foreground        none
      selection_background        none

      # Animated cursor follows text (was ml4w/settings/kitty-cursor-trail.conf)
      cursor_trail 1

      # Colors: static copy of the former colors-matugen.conf (wallpaper colors).
      # DMS/matugen may regenerate wallpaper colors; this copy is not updated automatically.
      cursor #f1dfd9
      cursor_text_color #d8c2bb

      foreground            #f1dfd9
      background            #1a110e
      selection_foreground  #442a20
      selection_background  #e7beaf
      url_color             #ffb59a

      # black
      color8   #f1dfd9
      color0   #4c4c4c

      # red
      color1   #ffb4ab
      color9   #c49ea0

      # green
      color2   #f1dfd9
      color10  #9ec49f

      # yellow
      color3   #aca98a
      color11  #c4c19e

      # blue
      color4  #ffb59a
      color12 #a39ec4

      # magenta
      color5   #ffb4ab
      color13  #c49ec4

      # cyan
      color6   #f1dfd9
      color14  #9ec3c4

      # white
      color15   #e7e7e7
      color7  #f0f0f0

      # (custom.conf did not exist on the source machine; nothing to inline)
    '';
  };
}
