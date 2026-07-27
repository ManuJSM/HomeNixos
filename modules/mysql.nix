{ config, lib, pkgs, ... }:

let
  cfg = config.services.azerothcore.mysql;
in
{
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;

    settings = {
      mysqld = {
        skip-log-bin = true;
        innodb_buffer_pool_size = "6G";
        innodb_buffer_pool_instances = 6;
        innodb_log_buffer_size = "32M";
        innodb_use_fdatasync = true;
        innodb_io_capacity = 500;
        innodb_io_capacity_max = 2500;
        transaction_isolation = "READ-COMMITTED";

        # ── Conexiones ──
        max_connections = 500;
        max_allowed_packet = "256M";
        wait_timeout = 600;
        interactive_timeout = 600;

        # ── Charset ──
        character-set-server = "utf8mb4";
        collation-server = "utf8mb4_unicode_ci";

        # ── Bind ──
        bind-address = "127.0.0.1";
        port = 3306;

        # ── Auth ──
        default_authentication_plugin = "mysql_native_password";
      };
    };
  };
}