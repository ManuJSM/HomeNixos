{ pkgs, ... }:

{
  users.users."shirok" = {
    isNormalUser = true;
    description = "shirok";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2QoT71MUrRSV4eRnxEAy2WWF9mok9w/NRT46CZPmBO shirok@fedora"
    ];
  };

  programs.zsh.enable = true;
  nix.settings.trusted-users = [ "shirok" ];
}
