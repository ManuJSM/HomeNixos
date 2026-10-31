{ pkgs, ... }:

{
  # helix: modal terminal text editor (vim-like, built-in LSP). Config files are
  # ported verbatim from ~/.config/helix (see ./helix/).
  programs.helix = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./helix/config.toml);
    languages = builtins.fromTOML (builtins.readFile ./helix/languages.toml);
    themes.kanagawa_transparent = builtins.fromTOML (builtins.readFile ./helix/kanagawa_transparent.toml);
    # Language servers / formatters referenced by languages.toml
    extraPackages = with pkgs; [
      typescript-language-server   # TS/JS/Vue language server
      prettier        # formatter for Vue
      rustfmt                      # Rust formatter
      ruff                         # Python linter/formatter
      gotools                      # provides goimports (Go formatter)
      nixfmt                       # Nix formatter
    ];
  };
}
