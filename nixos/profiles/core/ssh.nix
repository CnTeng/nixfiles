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

  mkPublicKey = host: type: publicKey: {
    "${host}-${type}" = {
      hostNames = [ "${host}.snakepi.xyz" ];
      inherit publicKey;
    };
  };

  knownHosts = lib.concatMapAttrs (
    host: hostData:
    lib.mergeAttrsList [
      (mkPublicKey host "rsa" hostData.host_rsa_key_pub)
      (mkPublicKey host "ed25519" hostData.host_ed25519_key_pub)
    ]
  ) hosts;

  matchBlocks = lib.concatMapAttrs (host: _: {
    ${host} = {
      hostname = "${host}.snakepi.xyz";
      inherit user;
      identityFile = [
        "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
        "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
      ];
    };
  }) hosts;
in
{
  programs.ssh.knownHosts = knownHosts;

  home-manager.users.${user} = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      inherit matchBlocks;
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".ssh" ];
  };
}
