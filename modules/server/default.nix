# Server-only services.
{ ... }:

{
  imports = [
    ./ssh.nix
    ./mysql.nix
    ./monitoring.nix
    ./backups.nix
    ./samba.nix
  ];
}
