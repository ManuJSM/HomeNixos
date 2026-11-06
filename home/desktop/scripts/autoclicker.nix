# auto-clicker: Python script that clicks the left mouse button N times/second via uinput.
#
#   auto-clicker --cps 40    # runs forever, stop with Ctrl+C
#   auto-clicker-toggle      # starts it in the background, or stops it if running
#
# Needs the `uinput` group (modules/desktop/niri.nix).
{ pkgs, ... }:

let
  clicker = pkgs.writers.writePython3Bin "auto-clicker"
    {
      libraries = [ pkgs.python3Packages.python-uinput ];
      flakeIgnore = [
        "E265"
        "E225"
        "E501"
        "W293" # Added to prevent builder from crashing on whitespace inside blank lines
      ];
    }
    ''
      import os
      import time
      import uinput
      import argparse

      # Set up command line argument parsing
      parser = argparse.ArgumentParser(description='Auto-clicker with configurable CPS')
      parser.add_argument('--cps', type=float, default=40.0, help='Clicks per second (default: 40)')
      args = parser.parse_args()

      # Calculate exact target interval length per click cycle
      click_delay = 1.0 / args.cps

      # Set up the uinput device
      keys = [uinput.BTN_LEFT]
      with open("/tmp/auto-clicker.pid", "w") as f:
          f.write(str(os.getpid()))

      # Remember to double-quote escape variables in Nix multiline strings (''${ ... })
      print(f"Starting precision auto-clicker at ''${args.cps} clicks per second")
      print(f"PID: ''${os.getpid()} (saved to /tmp/auto-clicker.pid)")

      device = uinput.Device(keys)
      time.sleep(0.2)  # Small initialization window before clicking loop starts

      try:
          # Initialize our monotonic anchor time
          next_click_time = time.perf_counter()

          while True:
              device.emit(uinput.BTN_LEFT, 1)  # Press
              device.emit(uinput.BTN_LEFT, 0)  # Release

              # Step our target anchor exactly forward by one interval block
              next_click_time += click_delay

              # Monotonic busy-wait loop for microsecond-accurate hardware timing
              while time.perf_counter() < next_click_time:
                  pass  # Keep polling until our target window hits exactly

      except KeyboardInterrupt:
          print("\nAuto-clicker stopped")
    '';

  toggle = pkgs.writeShellApplication {
    name = "auto-clicker-toggle";
    runtimeInputs = [
      clicker
      pkgs.coreutils
      pkgs.util-linux
    ];
    text = ''
      pid_file=/tmp/auto-clicker.pid

      if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        kill "$(cat "$pid_file")"
        rm -f "$pid_file"
      else
        rm -f "$pid_file"
        setsid auto-clicker --cps 40 >/dev/null 2>&1 &
      fi
    '';
  };
in
pkgs.symlinkJoin {
  name = "auto-clicker";
  paths = [
    clicker
    toggle
  ];
}
