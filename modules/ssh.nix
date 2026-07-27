{ config, lib, pkgs, ... }:

{
  # ── Servicio SSH ──
  services.openssh = {
    enable = true;
    openFirewall = true;
    ports = [ 22 ];               # Puerto estándar; cambiar para security-by-obscurity

    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };

    # HostKeys por defecto (se generan automáticamente)
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  # ── Known hosts (ejemplo, ajustar) ──
  programs.ssh.knownHosts = {
    # "git.tudominio.com".publicKey = "...";
  };

  # ── Sincronización de tiempo (NTP) ──
  services.ntp.enable = true;
  services.timesyncd.enable = lib.mkDefault true;
}
