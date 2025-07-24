{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.default ];

  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            label = "ESP";
            size = "2G";
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
                  swap.swapfile.size = "4G";
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
}
