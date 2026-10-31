# Desktop base shared by sobremesa (AMD) and portatil (Intel): niri + DMS + SDDM.
{ inputs, lib, ... }:

{
  imports = [
    ./graphics.nix
    ./nvidia.nix
    ./audio.nix
    ./fonts.nix
    ./niri.nix
    ./sddm.nix
    ./stylix.nix
    ./obs.nix
    ./unstable.nix
    ./docker.nix
  ];

  # ── Home-manager: desktop user config on top of home/common.nix ──
  # (merges with the `users.shirok` defined in modules/common)
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.shirok = import ../../home/desktop;
    # If a file already exists where HM wants a link, keep it as *.hm-backup
    backupFileExtension = "hm-backup";
  };

  # gvfs: virtual filesystems for Nautilus (trash, USB/MTP phones, smb:// network shares)
  services.gvfs.enable = true;
}
