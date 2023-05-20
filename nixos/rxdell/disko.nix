{inputs, ...}: {
  imports = [inputs.disko.nixosModules.disko];

  disko.devices = {
    disk.nvme = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "0";
            end = "512MB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "luks";
            start = "512MB";
            end = "-16GB";
            content = {
              type = "luks";
              name = "nixos";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "btrfs";
                extraArgs = ["-L nixos" "-f"];
                subvolumes = {
                  "/nix".mountOptions = ["noatime" "compress=zstd"];
                  "/persist".mountOptions = ["noatime" "compress=zstd"];
                };
              };
            };
          }
          {
            name = "swap";
            start = "-16GB";
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
      mountOptions = ["defaults" "mode=755"];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
