{ config, lib, pkgs, ... }:

{
  services.samba-wsdd.enable = true;

  environment.systemPackages = [ config.services.samba.package ];

  networking.firewall = {
    allowedTCPPorts = [ 5357 ];
    allowedUDPPorts = [ 3702 ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        "security" = "user";
        "invalid users" = [ "root" ];
        "hosts allow" = "127.0.0.1 192.168.1.0/24";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "guest ok" = "yes";
        "passdb backend" = "tdbsam";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
        <type>_smb._tcp</type>
        <port>445</port>
        </service>
        </service-group>
      '';
    };
  };
}
