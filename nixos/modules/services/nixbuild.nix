{
  config,
  lib,
  data,
  ...
}:
let
  cfg = config.services'.nixbuild;

  inherit (config.networking) hostName;
in
{
  options.services'.nixbuild.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    users.users.nixbuild.isNormalUser = true;
    users.users.nixbuild.openssh.authorizedKeys.keys = [ data.hosts.${hostName}.nixbuild_key_pub ];

    nix.settings.trusted-users = [ "nixbuild" ];
  };
}
