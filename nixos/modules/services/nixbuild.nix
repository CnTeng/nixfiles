{ config, lib, ... }:
let
  cfg = config.services'.nixbuild;

  inherit (config.networking) hostName;
in
{
  options.services'.nixbuild.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    users.users.nixbuild.isNormalUser = true;

    nix.settings.trusted-users = [ "nixbuild" ];

    services.openssh.authorizedKeysFiles = [ config.sops.secrets."ssh/nixbuild_key.pub".path ];

    sops.secrets."ssh/nixbuild_key.pub" = {
      key = "hosts/${hostName}/nixbuild_key_pair/public_key";
      mode = "0444";
    };
  };
}
