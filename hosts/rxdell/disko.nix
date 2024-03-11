{
  disko.devices = {
    disk.nvme = {
      device = "/dev/nvme0n1";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "512MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "luks";
            start = "512MiB";
            end = "-16GiB";
            content = {
              type = "luks";
              name = "nixos";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L nixos"
                  "-f"
                ];
                subvolumes = {
                  "/nix" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/nix";
                  };
                  "/persist" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/persist";
                  };
                };
              };
            };
          }
          {
            name = "swap";
            start = "-16GiB";
            end = "100%";
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
      mountOptions = [
        "defaults"
        "mode=755"
      ];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
