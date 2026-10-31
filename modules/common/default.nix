# Shared by every host (server, sobremesa, portatil).
{ inputs, ... }:

{
  imports = [
    ./packages.nix
    ./nix.nix
    ./nvim.nix
    ./ssh.nix
    ./users.nix
    ./kanata.nix
    ./firewall.nix
    ./locale.nix

    # ── Home-manager (config de usuario, shell común a todos los hosts) ──
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.shirok = import ../../home/common.nix;
      };
    }
  ];

  # Keep only the 10 newest generations in the boot menu (systemd-boot).
  boot.loader.systemd-boot.configurationLimit = 10;
}
