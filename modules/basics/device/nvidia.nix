{ pkgs, config, user, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  environment.systemPackages = [ nvidia-offload ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaPersistenced = true;
    modesetting.enable = true;

    prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement = {
      # enable = true;
      finegrained = true;
    };
  };

  home-manager.users.${user} = {
    home.packages = [ pkgs.pciutils ];
  };
}
