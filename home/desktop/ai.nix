# AI coding agents.
#
# gentle-ai configures these agents (persona, skills, workflows, Engram memory).
# It is packaged in scripts/gentle-ai.nix from the upstream static release
# binary; after installing, run `gentle-ai install --agent opencode`.
{ pkgs, ... }:

{
  # gentle-ai installs its companion binaries (engram, gga) into ~/.local/bin.
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    claude-code  # claude-code: Anthropic's AI coding agent for the terminal (`claude`)
    opencode     # opencode: open-source AI coding agent for the terminal (`opencode`)
    (pkgs.callPackage ./scripts/gentle-ai.nix { })  # gentle-ai: agent setup/memory
  ];
}
