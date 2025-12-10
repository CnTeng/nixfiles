{ inputs, config, ... }:
{
  imports = [ inputs.wsl.nixosModules.default ];

  wsl = {
    enable = true;
    defaultUser = config.core'.userName;
  };

  services.resolved.enable = false;
}
