{ inputs, ... }:

let
  unstable = system: inputs.nixpkgs-unstable.legacyPackages.${system};
in
{
  # Packages taken from nixpkgs-unstable; everything else stays on 26.05.
  nixpkgs.overlays = [
    (final: prev: {
      # DMS (dux-shell) builds its Go core with `pkgs.go_1_27` (core/go.mod says go 1.27),
      # which nixos-26.05 does not have. Remove once 26.05 / the DMS go.mod catch up.
      go_1_27 = (unstable prev.stdenv.hostPlatform.system).go_1_27;

      # opencode 2.x: 26.05 ships 1.15.x, the user wants the 2.x series.
      opencode = (unstable prev.stdenv.hostPlatform.system).opencode;

      # quickshell 0.3.2: DMS fails to load its shell (bar, IPC) on 26.05's 0.3.0.
      # Unstable's recipe, built against 26.05's Qt so it matches the QML modules
      # DMS loads (unstable's binary uses a newer Qt and would mismatch).
      quickshell = final.callPackage "${inputs.nixpkgs-unstable}/pkgs/by-name/qu/quickshell/package.nix" { };
    })
  ];
}
