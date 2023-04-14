{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.nvme = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            type = "partition";
            name = "ESP";
            start = "0";
            end = "512MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            type = "partition";
            name = "luks";
            start = "512MiB";
            end = "-16G";
            part-type = "primary";
            content = {
              type = "luks";
              name = "nixos";
              content = {
                type = "btrfs";
                extraArgs = [ "-L nixos" "-f" ];
                subvolumes = {
                  "/nix".mountOptions = [ "noatime" "compress=zstd" ];
                  "/persist".mountOptions = [ "noatime" "compress=zstd" ];
                };
              };
            };
          }
          {
            type = "partition";
            name = "swap";
            start = "-16G";
            end = "100%";
            part-type = "primary";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          }
        ];
      };
    };

    nodev."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=2G" "mode=755" ];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
