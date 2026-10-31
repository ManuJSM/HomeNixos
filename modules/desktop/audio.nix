{ ... }:

{
  # rtkit: lets PipeWire get realtime scheduling (glitch-free audio)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;          # PipeWire: audio + screen-capture server
    alsa.enable = true;     # ALSA apps go through PipeWire
    alsa.support32Bit = true;
    pulse.enable = true;    # PulseAudio compatibility (pavucontrol, most apps)
    wireplumber.enable = true;   # session manager that wires devices together
  };
}
