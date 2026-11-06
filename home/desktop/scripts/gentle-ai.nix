# gentle-ai: configures AI coding agents (OpenCode, Claude Code, ...) with
# persistent memory (Engram), skills, workflows and personas.
#
# Upstream ships a static Go binary (CGO_ENABLED=0) per release, so no patching
# is needed on NixOS. It is NOT in nixpkgs and the curl installer cannot work
# here (it edits ~/.zshrc, a read-only home-manager symlink), hence this file.
#
# Updating (two values below):
#   curl -sL https://github.com/Gentleman-Programming/gentle-ai/releases/latest/download/checksums.txt \
#     | grep linux_amd64
#   nix hash convert --hash-algo sha256 --to sri <hex-from-above>
#
# `gentle-ai upgrade` cannot work: the Nix store is read-only by design.
{ lib, stdenvNoCC, fetchurl }:

let
  version = "4.3.1";
  hash = "sha256-BOxoXFa0LCnf9tsQ/H3CxzAhfcnJZzblOtKs8yJtr7c=";
in
stdenvNoCC.mkDerivation {
  pname = "gentle-ai";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Gentleman-Programming/gentle-ai/releases/download/v${version}/gentle-ai_${version}_linux_amd64.tar.gz";
    inherit hash;
  };

  # The tarball has no top-level directory.
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 gentle-ai $out/bin/gentle-ai
    runHook postInstall
  '';

  meta = {
    description = "Configures AI coding agents with memory, skills and workflows";
    homepage = "https://github.com/Gentleman-Programming/gentle-ai";
    license = lib.licenses.mit;
    mainProgram = "gentle-ai";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
