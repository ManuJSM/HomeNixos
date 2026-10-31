# Laptop-only: power management, lid handling, brightness, battery notifications.
{ pkgs, ... }:

{
  # TLP: battery/power tuning daemon. Values taken from nixri, each one explained.
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";    # max clocks when plugged in
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";     # low clocks on battery
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";       # hardware hint: favour battery life
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";  # hardware hint: favour speed
      CPU_MIN_PERF_ON_AC = 0;                        # no lower perf bound on AC (%)
      CPU_MAX_PERF_ON_AC = 100;                      # full speed allowed on AC (%)
      CPU_MIN_PERF_ON_BAT = 0;                       # no lower perf bound on battery (%)
      CPU_MAX_PERF_ON_BAT = 50;                      # cap CPU at 50% on battery (nixri value; raise if sluggish)
      START_CHARGE_THRESH_BAT0 = 82;                 # start charging below 82% (needs supported hardware)
      STOP_CHARGE_THRESH_BAT0 = 95;                  # stop charging at 95% (preserves battery health)
      START_CHARGE_THRESH_BAT1 = 82;                 # same for a second battery, if present
      STOP_CHARGE_THRESH_BAT1 = 95;
    };
  };

  # power-profiles-daemon conflicts with TLP: keep it off
  services.power-profiles-daemon.enable = false;

  # Lid closed: suspend (on battery, on AC and when docked with an external screen)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "suspend";
  };

  environment.systemPackages = [
    pkgs.brightnessctl   # brightnessctl: set screen backlight from the shell
    (pkgs.callPackage ./batterynotify.nix { })   # batterynotify: low/full battery notifications
  ];

  # Run batterynotify automatically with the graphical session
  systemd.user.services.batterynotify = {
    description = "Battery notifications";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.callPackage ./batterynotify.nix { }}/bin/batterynotify --undock";
      Restart = "on-failure";
    };
  };
}
