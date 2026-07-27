{ config, lib, pkgs, ... }:

{
  # ── Paquetes esenciales ──
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    htop
    fastfetch
    rsync
    eza
    ripgrep
    jq
    iotop
    ncdu
    bind.dnsutils      # dig, nslookup
    openssl
    p7zip
    (python3.withPackages (p: with p; [
      pip
      # virtualenv
    ]))
  ];

  # ── Editor por defecto ──
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # ── Automatización de NixOS ──
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos#${config.networking.hostName}";
    flags = [
      "-L"
      "--accept-flake-config"
    ];
    dates = "Sat *-*-* 03:00:00";
    allowReboot = false;          # true si queremos que rebootee solo
  };

  # ── Podman/Docker ──
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   autoPrune.enable = true;
  #   defaultNetwork.settings.dns_enabled = true;
  # };
  # virtualisation.oci-containers.backend = "podman";

  # ── Seguridad ──
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;  # Usuarios en wheel pueden sudo sin pass
    };
    doas.enable = false;
  };
}
