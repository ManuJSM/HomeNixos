{ config, lib, pkgs, ... }:

let
  cfg = config.services.restic.backups;
  adminEmail = config.server.adminEmail;
in
{
  # ── Backups con Restic ──
  # Descomentar/configurar según necesidad

  services.restic = {
    # backups = {
    #   system = {
    #     paths = [
    #       "/etc"
    #       "/var/lib"
    #     ];
    #     exclude = [
    #       "/var/lib/docker"
    #       "/var/lib/postgresql/*/base"
    #     ];
    #     repository = "s3:https://s3.tudominio.com/bucket-name";
    #     environmentFile = "/etc/restic-env";
    #     passwordFile = "/etc/restic-password";
    #     initialize = true;
    #     timerConfig = {
    #       OnCalendar = "daily";
    #       Persistent = true;
    #     };
    #     pruneOpts = [
    #       "--keep-daily 7"
    #       "--keep-weekly 4"
    #       "--keep-monthly 3"
    #     ];
    #   };
    # };

    # Servidor Restic local (para backups en red local)
    # server = {
    #   enable = true;
    #   dataDir = "/mnt/backups/restic";
    # };
  };
}
