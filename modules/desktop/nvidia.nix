{ config, lib, ... }:

{
  # Off by default and not used by any host. A host with an NVIDIA GPU sets
  # `desktop.nvidia.enable = true;`.
  options.desktop.nvidia.enable = lib.mkEnableOption "proprietary NVIDIA driver";

  config = lib.mkIf config.desktop.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];   # load the NVIDIA kernel/userspace driver
    hardware.nvidia = {
      modesetting.enable = true;   # KMS, required for Wayland compositors (niri)
      open = false;                # proprietary kernel module (not the open one)
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
