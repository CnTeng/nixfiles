{
  config,
  lib,
  data,
  user,
  ...
}:
let
  inherit (config.networking) hostName;

  hosts = lib.filterAttrs (n: v: n != hostName && v.type == "remote") data.hosts;

  knownHosts = lib.mkKnownHosts hosts;
  matchBlocks = lib.mkMatchBlocks user hosts;
in
{
  programs.ssh.knownHosts = knownHosts;

  home-manager.users.${user} = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      includes = [ "config.d/*.conf" ];
      inherit matchBlocks;
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".ssh" ];
  };
}
