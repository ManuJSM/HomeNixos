{
  description = "Configuración básica de servidor NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Desktop (sobremesa / portatil) ──
    # nixpkgs-unstable: ONLY for `go_1_27` (DMS needs Go 1.27), `opencode` 2.x and the quickshell 0.3.2 recipe; absent from 26.05.
    # See modules/desktop/unstable.nix.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # niri-flake: niri compositor NixOS/home-manager modules + typed settings
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dms: DankMaterialShell (bar, launcher, notifications, lock screen, wallpaper)
    dms = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helium: Helium browser (Chromium-based, privacy oriented)
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # silentSDDM: themed SDDM login screen
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      mkHost =
        hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit self;
          };
          modules = [ hostModule ];
        };
    in
    {
      # Attribute name must equal networking.hostName (autoUpgrade uses it).
      nixosConfigurations = {
        nixos = mkHost ./hosts/server;      # server (hostname "nixos")
        sobremesa = mkHost ./hosts/sobremesa; # AMD desktop
        portatil = mkHost ./hosts/portatil;   # Intel laptop
      };
    };
}
