{ lib, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
    settings = {
      mysqld = {
        bind-address = "127.0.0.1";
        port = 3306;
      };
    };
  };
}
