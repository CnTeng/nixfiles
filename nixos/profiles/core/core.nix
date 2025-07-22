{ config, lib, ... }:
let
  cfg = config.core';
in
{
  options.core' = {
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };

    hostName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.user != null;
        message = "User must be specified in core'.user";
      }
      {
        assertion = cfg.hostName != null;
        message = "Host name must be specified in core'.hostName";
      }
    ];

    networking.hostName = cfg.hostName;
  };
}
