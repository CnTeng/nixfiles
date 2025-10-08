{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.hardware'.stateless;

  user = config.core'.userName;
  storage = "/persist";
in
{
  imports = [
    inputs.preservation.nixosModules.default
    inputs.ph.nixosModules.default

    (lib.mkAliasOptionModule [ "preservation'" "os" ] [ "preservation" "preserveAt" storage ])
    (lib.mkAliasOptionModule
      [ "preservation'" "user" ]
      [ "preservation" "preserveAt" storage "users" user ]
    )
  ];

  options.hardware'.stateless.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    boot.tmp.useTmpfs = true;

    preservation = {
      enable = true;
      preserveAt."/persist" = {
        commonMountOptions = [ "x-gvfs-hide" ];

        directories = [
          {
            directory = "/var/lib/machines";
            mode = "0700";
          }
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          {
            directory = "/var/lib/private";
            mode = "0700";
          }
          "/var/lib/systemd"

          "/var/log"
          "/var/cache/private"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        users.${user}.directories = [
          ".cache/nix"
          ".local/share/nix"
          ".local/state/nix"
        ];
      };
    };

    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
    systemd.services.systemd-machine-id-commit.unitConfig.ConditionFirstBoot = true;

    programs.ph.enable = true;
  };
}
