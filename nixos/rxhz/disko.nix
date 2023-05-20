{inputs, ...}: {
  imports = [inputs.disko.nixosModules.disko];

  disko.devices = {
    disk.sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            start = "0";
            end = "1MB";
            flags = ["bios_grub"];
          }
          {
            name = "nixos";
            start = "1MB";
            end = "-8GB";
            content = {
              type = "btrfs";
              extraArgs = ["-L nixos" "-f"];
              subvolumes = {
                "/boot".mountOptions = ["noatime" "compress=zstd"];
                "/nix".mountOptions = ["noatime" "compress=zstd"];
                "/persist".mountOptions = ["noatime" "compress=zstd"];
              };
            };
          }
          {
            name = "swap";
            start = "-8GB";
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
