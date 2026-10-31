# PLACEHOLDER: replace with the output of `nixos-generate-config` on the real machine
# (run it on the installed system and copy /etc/nixos/hardware-configuration.nix here).
{ ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };
}
