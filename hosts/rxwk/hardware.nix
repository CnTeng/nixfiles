{ inputs, ... }:
{
  imports = [ inputs.wsl.nixosModules.default ];

  wsl = {
    enable = true;
    defaultUser = "yufei";
  };
}
