{ lib, pkgs, ... }:

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

        max_connections = 500;
        max_allowed_packet = "256M";
        wait_timeout = 600;
        interactive_timeout = 600;

        character-set-server = "utf8mb4";
        collation-server = "utf8mb4_unicode_ci";

        bind-address = "127.0.0.1";
        port = 3306;

        };
    };
  };
}
