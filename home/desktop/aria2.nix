{ pkgs, ... }:

{
  # aria2: CLI downloader (HTTP/FTP/BitTorrent/magnet, multi-connection)
  home.packages = [ pkgs.aria2 ];

  # Background aria2 RPC daemon (so web UIs / browser extensions can queue downloads)
  systemd.user.services.aria2 = {
    Unit = {
      Description = "Aria2 Download Manager Daemon";
      After = [ "network.target" ];
    };
    Service = {
      # No --dir flag: manual CLI usage is not restricted
      ExecStart = "${pkgs.aria2}/bin/aria2c --enable-rpc --rpc-listen-all=false";
      WorkingDirectory = "%h";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
