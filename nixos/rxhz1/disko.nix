{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.sda = {
      type = "disk";
      device = "/dev/sda";
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
            name = "nixos";
            start = "512MiB";
            end = "-8GiB";
            content = {
              type = "btrfs";
              extraArgs = [ "-L nixos" "-f" ];
              subvolumes = {
                "/nix".mountOptions = [ "noatime" "compress=zstd" ];
                "/persist".mountOptions = [ "noatime" "compress=zstd" ];
              };
            };
          }
          {
            name = "swap";
            start = "-8GiB";
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
      mountOptions = [ "defaults" "mode=755" ];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
