{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"

    ../../modules/hardware
  ];

  custom.hardware.kernel.modules.bbr = true;
}
