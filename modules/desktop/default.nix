# Desktop base shared by sobremesa (AMD) and portatil (Intel): niri + DMS + SDDM.
{ inputs, lib, ... }:

{
  imports = [
    ./graphics.nix
    ./nvidia.nix
    ./audio.nix
    ./fonts.nix
    ./theming.nix
    ./niri.nix
    ./sddm.nix
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

  # AccountsService: stores the user profile picture in /var/lib/AccountsService.
  # DMS (home-manager module) uses it to persist the avatar; without it, the
  # image only lives in DMS's memory and disappears when DMS restarts.
  services.accounts-daemon.enable = true;

  # SDDM stops the greeter before starting the session, so the new VT briefly
  # shows the raw console (kernel + systemd messages) during login. SDDM has no
  # option to keep the greeter on screen, so silence the console instead: the
  # transition becomes black. consoleLogLevel=3 still shows real errors.
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" "vt.global_cursor_default=0" ];
  systemd.settings.Manager.ShowStatus = false;
  systemd.user.extraConfig = ''
    ShowStatus=no
  '';
}
