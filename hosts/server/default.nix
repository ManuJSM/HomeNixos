{ inputs, lib, pkgs, ... }:
let
  hostName = "nixos";
in
{
  imports = [
    # ⚠️ COPIAR hardware-configuration.nix del servidor aquí
    # (hosts/server/hardware-configuration.nix; must be git-tracked or the flake ignores it)
    ./hardware-configuration.nix

    ../../modules/common
    ../../modules/server
  ];

  # ── Identidad del host ──
  networking = {
    inherit hostName;
    firewall.enable = lib.mkDefault true;
    networkmanager.enable = true;
  };

  # ── Bootloader ──
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ── Discos vienen de hardware-configuration.nix ──

  # ── Shares Samba ──
  services.samba.settings = {
    sharefolder = {
      path = "/srv/sharefolder";
      "guest ok" = "yes";
      "browseable" = "yes";
      "writable" = "no";
      "write list" = "shirok";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/sharefolder 0775 root users - -"
  ];

  # ── Al cerrar tapa del portátil no hace nada ──
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  system.stateVersion = "26.05";
}
