{ config, ... }:

let
  inherit (config.lib.niri) actions;
  dms = actions.spawn "dms" "ipc" "call";   # shorthand: dms ipc call <target> <function>
  ws = n: toString n;
in
{
  # niri: scrollable-tiling Wayland compositor (settings via niri-flake).
  programs.niri.settings = {
    input = {
      keyboard = {
        xkb.layout = "us";
        repeat-delay = 275;
        repeat-rate = 35;
        track-layout = "global";
      };
      touchpad = {
        click-method = "clickfinger";   # 1/2/3-finger click = left/right/middle
        tap = true;                     # tap to click
      };
      mouse = {
        accel-profile = "flat";
        accel-speed = 0.0;
      };
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
      warp-mouse-to-focus.enable = true;
    };

    # niri's default: the top-left corner of each monitor toggles the overview
    # (all workspaces zoomed out). With two monitors, the second one's corner is
    # in the middle of the desktop, so it triggers by accident when moving the
    # mouse along the top edge.
    gestures.hot-corners.enable = false;

    cursor = {
      theme = "Bibata-Modern-Classic";   # same as home.pointerCursor
      size = 24;
    };
    prefer-no-csd = true;                         # ask apps to drop client-side decorations
    hotkey-overlay.skip-at-startup = true;        # open the keybind cheat-sheet with Mod+Shift+Slash

    environment = {
      NIXOS_OZONE_WL = "1";                       # Electron/Chromium apps use Wayland
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      MOZ_ENABLE_WAYLAND = "1";                   # Firefox on Wayland
    };

    layout = {
      gaps = 8;
      center-focused-column = "never";
      # New windows open as a full-width column (Mod+R cycles the preset widths).
      default-column-width = { proportion = 1.0; };
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 1;
        active.color = "#7e9cd8";                 # kanagawa blue (DMS colours may override)
        inactive.color = "transparent";
      };
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];
    };

    window-rules = [
      {
        # rounded corners for every window
        geometry-corner-radius = let r = 12.0; in { top-left = r; top-right = r; bottom-left = r; bottom-right = r; };
        clip-to-geometry = true;
        # niri paints the border as a solid rectangle behind the window by
        # default, which hides transparency (kitty background_opacity).
        draw-border-with-background = false;
      }
      {
        # DMS popups (settings etc.) float
        matches = [ { app-id = "^(dev\\.duxlabs\\.shell|com\\.danklinux\\.dms)$"; } ];
        open-floating = true;
      }
      {
        # browser picture-in-picture floats
        matches = [ { title = "^Picture-in-Picture$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "mpv"; } ];
        open-maximized = true;
      }
    ];

    binds = {
      # ── Apps ──
      "Mod+Return" = { action = actions.spawn "kitty"; hotkey-overlay.title = "Terminal (kitty)"; };
      "Mod+E" = { action = actions.spawn "nautilus"; hotkey-overlay.title = "File manager (Nautilus)"; };
      "Mod+Alt+E" = { action = actions.spawn "kitty" "superfile"; hotkey-overlay.title = "Terminal file manager (superfile)"; };
      "Mod+F" = { action = actions.fullscreen-window; hotkey-overlay.title = "Fullscreen"; };
      "Mod+Shift+F" = { action = actions.spawn "helium"; hotkey-overlay.title = "Helium browser"; };
      "Mod+Shift+B" = { action = actions.spawn "vimb"; hotkey-overlay.title = "vimb browser"; };
      "Mod+D" = { action = dms "spotlight" "toggle"; hotkey-overlay.title = "App launcher (DMS)"; };

      # ── DMS shell ──
      "Mod+N" = { action = dms "notifications" "toggle"; hotkey-overlay.title = "Notification center"; };
      "Mod+Comma" = { action = dms "settings" "toggle"; hotkey-overlay.title = "DMS settings"; };
      "Mod+V" = { action = dms "clipboard" "toggle"; hotkey-overlay.title = "Clipboard history"; };
      "Mod+X" = { action = dms "powermenu" "toggle"; hotkey-overlay.title = "Power menu"; };
      "Mod+Alt+L" = { action = dms "lock" "lock"; hotkey-overlay.title = "Lock screen (DMS)"; };
      "Mod+Alt+N" = { action = dms "night" "toggle"; hotkey-overlay.title = "Night mode"; };
      "Mod+Ctrl+S" = { action = dms "processlist" "toggle"; hotkey-overlay.title = "Process list"; };

      # ── Session / windows ──
      "Mod+Shift+Slash".action = actions.show-hotkey-overlay;

      # ── Monitors (Mod+F1/F2 = left/right screen, Mod+F3 = cycle to next screen) ──
      "Mod+F1" = { action = actions.focus-monitor-left; hotkey-overlay.title = "Focus left monitor"; };
      "Mod+F2" = { action = actions.focus-monitor-right; hotkey-overlay.title = "Focus right monitor"; };
      "Mod+F3" = { action = actions.focus-monitor-next; hotkey-overlay.title = "Focus next monitor"; };
      # Mod+Shift+F1/F2/F3: move the focused window to that monitor
      "Mod+Shift+F1" = { action = actions.move-window-to-monitor-left; hotkey-overlay.title = "Move window to left monitor"; };
      "Mod+Shift+F2" = { action = actions.move-window-to-monitor-right; hotkey-overlay.title = "Move window to right monitor"; };
      "Mod+Shift+F3" = { action = actions.move-window-to-monitor-next; hotkey-overlay.title = "Move window to next monitor"; };
      "Mod+Q".action = actions.close-window;
      "Alt+F4".action = actions.close-window;
      "Mod+Shift+E".action = actions.quit;
      "Mod+O".action = actions.toggle-overview;

      # ── Screenshots (niri native) ──
      "Print".action.screenshot = [ ];
      "Mod+Shift+S".action.screenshot = [ ];
      "Ctrl+Print".action = { screenshot-screen = [ ]; };
      "Alt+Print".action = { screenshot-window = [ ]; };

      # ── Focus ──
      "Mod+Left".action = actions.focus-column-left;
      "Mod+Right".action = actions.focus-column-right;
      "Mod+H".action = actions.focus-column-left;
      "Mod+L".action = actions.focus-column-right;
      "Mod+Up".action = actions.focus-window-or-workspace-up;
      "Mod+Down".action = actions.focus-window-or-workspace-down;
      "Mod+K".action = actions.focus-window-or-workspace-up;
      "Mod+J".action = actions.focus-window-or-workspace-down;
      "Mod+WheelScrollDown".action = actions.focus-workspace-down;
      "Mod+WheelScrollUp".action = actions.focus-workspace-up;

      # ── Move ──
      "Mod+Ctrl+Left".action = actions.move-column-left;
      "Mod+Ctrl+Right".action = actions.move-column-right;
      "Mod+Ctrl+H".action = actions.move-column-left;
      "Mod+Ctrl+L".action = actions.move-column-right;
      "Mod+Ctrl+Up".action = actions.move-window-up-or-to-workspace-up;
      "Mod+Ctrl+Down".action = actions.move-window-down-or-to-workspace-down;
      "Mod+Ctrl+K".action = actions.move-window-up-or-to-workspace-up;
      "Mod+Ctrl+J".action = actions.move-window-down-or-to-workspace-down;
      "Mod+Alt+Up".action = actions.move-workspace-up;
      "Mod+Alt+Down".action = actions.move-workspace-down;

      # ── Layout ──
      "Mod+R".action = actions.switch-preset-column-width;
      "Mod+M".action = actions.maximize-column;
      "Mod+C".action = actions.center-column;
      "Mod+Shift+V".action = actions.toggle-window-floating;
      "Mod+S".action = actions.switch-focus-between-floating-and-tiling;
      "Mod+Equal".action = actions.set-column-width "+10%";
      "Mod+Minus".action = actions.set-column-width "-10%";
      "Mod+Shift+Equal".action = actions.set-window-height "+10%";
      "Mod+Shift+Minus".action = actions.set-window-height "-10%";

      # ── Hardware keys (volume/brightness through DMS so its OSD shows) ──
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action = dms "audio" "increment" "3"; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action = dms "audio" "decrement" "3"; };
      "XF86AudioMute" = { allow-when-locked = true; action = dms "audio" "mute"; };
      "XF86AudioMicMute" = { allow-when-locked = true; action = dms "audio" "micmute"; };
      "XF86MonBrightnessUp" = { allow-when-locked = true; action = dms "brightness" "increment" "5" ""; };
      "XF86MonBrightnessDown" = { allow-when-locked = true; action = dms "brightness" "decrement" "5" ""; };
      "XF86AudioPlay".action = actions.spawn "playerctl" "play-pause";
      "XF86AudioPause".action = actions.spawn "playerctl" "play-pause";
      "XF86AudioNext".action = actions.spawn "playerctl" "next";
      "XF86AudioPrev".action = actions.spawn "playerctl" "previous";
    }
    # Mod+1..9 focus workspace, Mod+Shift+1..9 move column there
    // builtins.listToAttrs (builtins.concatLists (builtins.genList (i: let n = i + 1; in [
      { name = "Mod+${ws n}"; value.action = actions.focus-workspace n; }
      { name = "Mod+Shift+${ws n}"; value.action.move-column-to-workspace = n; }
    ]) 9));
  };
}
