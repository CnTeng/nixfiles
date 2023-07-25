{inputs, ...}: {
  imports = [inputs.nixos-wsl.nixosModules.default];

  wsl = {
    enable = true;
    # nativeSystemd = true;
    defaultUser = "yufei";
  };
}
