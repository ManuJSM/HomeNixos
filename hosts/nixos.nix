{ inputs, lib, pkgs, ... }:
let
  hostName = "nixos";
in
{
  imports = [
    # ⚠️ COPIAR hardware-configuration.nix del servidor aquí
    ./hardware-configuration.nix

    ../modules/common.nix
    ../modules/nix.nix
    ../modules/nvim.nix
    ../modules/ssh.nix
    ../modules/users.nix
    ../modules/kanata.nix
    ../modules/firewall.nix

    # ── Home-manager (config de usuario) ──
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.shirok = import ../home/shirok.nix;
      };
    }

    # Servicios
    ../modules/mysql.nix
    ../modules/monitoring.nix
    ../modules/backups.nix
    ../modules/samba.nix
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

  # ── Zona horaria ──
  time.timeZone = "Europe/Madrid";

  # ── Locale ──
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

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
