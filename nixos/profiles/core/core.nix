{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.core';

  hashedPassword = "$y$j9T$riMCfL.4mC/J482G5yj..1$d1hE7FKgRGPGtO.d4sIWVT6NB0x6RIIH46ZsZB.YUe.";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    (lib.mkAliasOptionModule [ "user'" ] [ "users" "users" cfg.userName ])
    (lib.mkAliasOptionModule [ "hm'" ] [ "home-manager" "users" cfg.userName ])
  ];

  options.core' = {
    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };

    hostName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };

    hostInfo = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
    };

    stateVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.userName != null;
        message = "User name must be specified in core'.userName";
      }
      {
        assertion = cfg.hostName != null;
        message = "Host name must be specified in core'.hostName";
      }
      {
        assertion = cfg.hostInfo != null;
        message = "Host info must be specified in core'.hostInfo";
      }
      {
        assertion = cfg.stateVersion != null;
        message = "State version must be specified in core'.stateVersion";
      }
    ];

    users.mutableUsers = true;

    users.users = {
      root = {
        inherit hashedPassword;
      };
      ${cfg.userName} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        inherit hashedPassword;
      };
    };

    networking = {
      inherit (cfg) hostName;
      domain = "snakepi.xyz";
    };

    time.timeZone = "Asia/Shanghai";

    system.stateVersion = cfg.stateVersion;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    home-manager.users.${cfg.userName} = {
      home.stateVersion = cfg.stateVersion;

      xdg.enable = true;
      home.preferXdgDirectories = true;
    };
  };
}
