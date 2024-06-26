{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.hardware'.disko;
in
{
  imports = [ inputs.disko.nixosModules.default ];

  options.hardware'.disko = {
    enable = lib.mkEnableOption' { };
    device = lib.mkOption {
      type = lib.types.str;
      visible = false;
    };
    bootSize = lib.mkOption {
      type = lib.types.str;
      visible = false;
    };
    swapSize = lib.mkOption {
      type = lib.types.str;
      visible = false;
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = {
      disk.${cfg.device} = {
        type = "disk";
        device = "/dev/" + cfg.device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              label = "ESP";
              size = cfg.bootSize;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              label = "ROOT";
              size = "100%";
              content = {
                type = "luks";
                name = "nixos";
                passwordFile = "/tmp/disk.key";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/nix" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/nix";
                    };
                    "/persist" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/persist";
                    };
                    "/swap" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/swap";
                      swap.swapfile.size = cfg.swapSize;
                    };
                  };
                };
              };
            };
          };
        };
      };

      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "mode=755" ];
      };
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
