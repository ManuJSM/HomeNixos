{ ... }:

{
  # OBS Studio: recording/streaming. Screen capture works through PipeWire +
  # xdg-desktop-portal-gnome (set up in niri.nix): add a "Screen Capture (PipeWire)" source.
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;   # v4l2loopback virtual webcam output
  };
}
