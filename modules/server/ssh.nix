# SSH server: only hosts that import modules/server (i.e. the server) run sshd.
{ ... }:

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

  # ── Clave pública autorizada para shirok ──
  users.users.shirok.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2QoT71MUrRSV4eRnxEAy2WWF9mok9w/NRT46CZPmBO shirok@fedora"
  ];

  # ── Fail2ban (protección contra brute-force en SSH) ──
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "5m";
    bantime-increment = {
      enable = true;
      maxtime = "24h";
    };
  };
}
