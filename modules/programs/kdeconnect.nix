{ pkgs, user, ... }:

{
  networking.firewall = {
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
  };

  programs.kdeconnect.enable = true;
  home-manager.users.${user} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
