{ ... }:

{
  # ── Firewall básico ──
  # Host-specific ports (e.g. 22 for the server) are opened by their own modules.
  networking.firewall = {
    enable = true;

    # Puertos abiertos globalmente
    allowedTCPPorts = [ ];

    allowedUDPPorts = [ ];

    # Reject ICMP (ping) — opcional
    # extraCommands = ''
    #   iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT
    #   ip6tables -A INPUT -p icmpv6 --icmp-type echo-request -j REJECT
    # '';
  };
}
