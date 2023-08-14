{inputs, ...}: {
  imports = [inputs.disko.nixosModules.default];

  disko.devices = {
    disk.sda = {
      # type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            label = "EFI";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          nixos = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-L nixos" "-f"];
              subvolumes = {
                "/nix" = {
                  mountOptions = ["noatime" "compress=zstd"];
                  mountpoint = "/nix";
                };
                "/persist" = {
                  mountOptions = ["noatime" "compress=zstd"];
                  mountpoint = "/persist";
                };
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["defaults" "mode=755"];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
