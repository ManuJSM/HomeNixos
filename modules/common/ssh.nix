# SSH client: available on every host. The server daemon lives in modules/server/ssh.nix.
{ lib, ... }:

{
  # ── Cliente SSH ──
  programs.ssh = {
    enable = true;                # installs the OpenSSH client and manages /etc/ssh/ssh_config

    # ── Known hosts (ejemplo, ajustar) ──
    knownHosts = {
      # "git.tudominio.com".publicKey = "...";
    };
  };

  # ── Sincronización de tiempo (NTP) ──
  services.ntp.enable = true;
  services.timesyncd.enable = lib.mkDefault true;
}
