{ pkgs, ... }:

{
  # One config for both AMD and Intel: the kernel autoloads amdgpu / i915 / xe,
  # and Mesa serves both. Only the video-acceleration (VA-API) drivers differ.
  hardware.graphics = {
    enable = true;        # OpenGL/Vulkan stack (Mesa)
    enable32Bit = true;   # 32-bit GL for Steam/Wine style apps
    extraPackages = with pkgs; [
      intel-media-driver   # VA-API hardware video decode/encode on Intel iGPUs
      libva-vdpau-driver   # VA-API on top of VDPAU (older/other GPUs fallback)
    ];
  };

  # Non-free firmware blobs (amdgpu, Intel wifi/bluetooth, etc.)
  hardware.enableRedistributableFirmware = true;

  # Bluetooth stack (BlueZ); DMS has a bluetooth applet to manage devices
  hardware.bluetooth = {
    enable = true;
    # BlueZ's Policy.AutoEnable: true powers the adapter on at every boot.
    # BlueZ cannot remember the last state, so keep it always on.
    powerOnBoot = true;
  };
}
