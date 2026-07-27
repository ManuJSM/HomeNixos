{ lib, ... }:

{
  # ── Configuración del daemon de Nix ──
  nix = {
    settings = {
      # Features experimentales necesarias para flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Máximo número de conexiones paralelas
      max-jobs = lib.mkDefault "auto";
      # Permitir sustitución de binarios desde cachés
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-users = [ "root" ];
    };

    # Limpieza automática del store
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
      persistent = true;
    };

    # Optimización automática del store
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # ── Permitir paquetes no-libres ──
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  # ── Permitir paquetes inseguros (si es necesario) ──
  nixpkgs.config.permittedInsecurePackages = [ ];
}
