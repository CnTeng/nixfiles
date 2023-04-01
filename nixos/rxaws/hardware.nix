{ modulesPath, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  hardware'.kernel.modules.bbr = true;
}
