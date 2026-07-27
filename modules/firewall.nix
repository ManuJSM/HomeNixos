{ config, lib, ... }:

{
  # ── Firewall básico ──
  networking.firewall = {
    enable = true;

    # Puertos abiertos globalmente
    allowedTCPPorts = [
      22    # SSH
    ];

    allowedUDPPorts = [ ];

    # Reject ICMP (ping) — opcional
    # extraCommands = ''
    #   iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT
    #   ip6tables -A INPUT -p icmpv6 --icmp-type echo-request -j REJECT
    # '';
  };

  # ── Fail2ban (protección contra brute-force) ──
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
