{ config, inputs, pkgs, ... }:

let
  colors = import ./palette.nix;

  # vimb needs GStreamer plugins for media and a dark GTK theme
  vimbWrapped = pkgs.symlinkJoin {
    name = "vimb-wrapped";
    paths = [ pkgs.vimb ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/vimb \
        --set GDK_BACKEND "wayland,x11" \
        --set GTK_THEME "Adwaita:dark" \
        --set ADW_DEBUG_COLOR_SCHEME "prefer-dark" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"
    '';
  };
in
{
  # firefox: general-purpose web browser
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "es-ES" ];
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "geo.enabled" = false;
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
      };
    };
  };

  home.packages = [
    # helium: Chromium-based privacy-oriented browser (from its own flake)
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    # vimb: keyboard-driven minimal WebKit browser (vim-like)
    vimbWrapped
    pkgs.pinentry-gnome3   # GUI passphrase prompt for gpg
  ] ++ (with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  # vimb: ad-filter / popup-blocker user script
  xdg.configFile."vimb/scripts.js".source = ./vimb/scripts.js;

  # vimb: dark stylesheet using the kanagawa palette (./palette.nix)
  xdg.configFile."vimb/style.css".text = ''
    html, body {
      background: #${colors.base00} !important;
      background-color: #${colors.base00} !important;
      background-image: none !important;
      color: #${colors.base05} !important;
    }
    div, main, article, section, header, footer, nav, aside,
    table, thead, tbody, tfoot, tr, td, th,
    ul, ol, li, dl, dt, dd {
      background-color: #${colors.base00} !important;
      background-image: none !important;
      color: #${colors.base05} !important;
      border-color: #${colors.base02} !important;
    }
    h1, h2, h3, h4, h5, h6 { color: #${colors.base0D} !important; background-color: transparent !important; }
    p, span, label { color: #${colors.base05} !important; }
    a, a * { color: #${colors.base0C} !important; }
    a:hover, a:focus, a:hover *, a:focus * { color: #${colors.base0A} !important; }
    a:visited, a:visited * { color: #${colors.base08} !important; }
    input, textarea, select, button, pre, code {
      background-color: #${colors.base01} !important;
      background-image: none !important;
      color: #${colors.base05} !important;
      border: 1px solid #${colors.base03} !important;
    }
    img, svg, video, canvas, picture,
    [class*="cover"], [class*="avatar"], [class*="badge"] { background-color: transparent !important; }
    span[vimbhint^='label'] {
      background-color: #${colors.base01} !important;
      color: #${colors.base05} !important;
      border: 1px solid #${colors.base03} !important;
      font-weight: bold !important;
      border-radius: 2px !important;
      padding: 1px 3px !important;
    }
    span[vimbhint='label focus'] { background-color: #${colors.base02} !important; color: #${colors.base0B} !important; }
    *[vimbhint^='hint'] { background-color: #${colors.base0B} !important; color: #${colors.base00} !important; }
    *[vimbhint='hint focus'] {
      background-color: #${colors.base01} !important;
      color: #${colors.base0B} !important;
      outline: 2px solid #${colors.base0B} !important;
    }
  '';

  # vimb: main settings
  xdg.configFile."vimb/config".text = ''
    set home-page=https://duckduckgo.com
    set download-path=~/Downloads/
    set stylesheet=true
    set javascript-can-open-windows-automatically=false
    set cookie-accept=always
    set default-zoom=140

    shortcut-default duck
    shortcut-add duck=https://duckduckgo.com/?q=$0
    shortcut-add y=http://www.youtube.com/results?search_query=$0

    autocmd LoadStarted * set scripts=on

    nmap ,s :set scripts!<CR>
  '';
}
