{ pkgs, ... }:

{
  users.users."shirok" = {
    isNormalUser = true;
    description = "shirok";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  nix.settings.trusted-users = [ "shirok" ];
}
