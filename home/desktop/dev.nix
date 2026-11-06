# Development toolchains and IDEs.
#
# Rust: nixpkgs `rustc` + `cargo` instead of `rustup`, because rustup's
# downloaded toolchains are generic Linux binaries (they expect
# /lib64/ld-linux-x86-64.so.2) and do not run on NixOS without nix-ld.
# `gcc` is required: rustc links through `cc`, which NixOS does not provide
# by default.
{ pkgs, ... }:

let
  # Shared by VSCodium and VS Code so both stay identical.
  vscodeSettings = {
    "workbench.activityBar.location" = "top";
    "workbench.iconTheme" = "catppuccin-macchiato";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "git.enableSmartCommit" = true;
    "editor.fontSize" = 16;
    "terminal.integrated.fontSize" = 15;
    "editor.minimap.enabled" = false;                       # no minimap
    "editor.stickyScroll.enabled" = false;                  # no sticky scroll
    "workbench.secondarySideBar.defaultVisibility" = "hidden";  # no right panel
    "chat.disableAIFeatures" = true;                        # no AI/chat
  };

  # liteclienthq.liteclient is not packaged in nixpkgs: it stays installed from
  # the GUI (the extensions dir is mutable), so it is not listed here.
  vscodeExtensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
    esbenp.prettier-vscode
    gruntfuggly.todo-tree
    jnoortheen.nix-ide
    redhat.vscode-xml
    usernamehw.errorlens
    vscodevim.vim
  ];
in
{
  home.packages = with pkgs; [
    rustc   # Rust compiler (`rustc`)
    cargo   # Rust package manager / build tool (`cargo`)
    go      # Go toolchain (`go`, `gofmt`)
    gcc     # C linker used by rustc and by Go's cgo
  ];

  # Note: User/settings.json becomes a read-only symlink, so changes made from
  # the GUI won't be saved; edit this file instead.
  #
  # VSCodium uses the FHS variant so it can coexist with `vscode` (both ship
  # lib/vscode/resources.pak).
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default = {
      userSettings = vscodeSettings;
      extensions = vscodeExtensions;
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = vscodeSettings;
      extensions = vscodeExtensions;
    };
  };
}
