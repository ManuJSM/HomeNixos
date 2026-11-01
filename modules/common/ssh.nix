# SSH client: available on every host. The server daemon lives in modules/server/ssh.nix.
{ lib, ... }:

{
  # ── Cliente SSH ──
  # `programs.ssh.enable` no existe en NixOS (solo en home-manager): el cliente
  # ya viene en el sistema, aquí solo se ajusta /etc/ssh/ssh_config.
  programs.ssh = {
    # ── Known hosts (ejemplo, ajustar) ──
    knownHosts = {
      # "git.tudominio.com".publicKey = "...";
    };
  };

  # ── Sincronización de tiempo (NTP) ──
  services.ntp.enable = true;
  services.timesyncd.enable = lib.mkDefault true;
}
