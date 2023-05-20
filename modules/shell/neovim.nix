{
  inputs,
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.neovim;
in {
  options.shell'.neovim = {
    enable = mkEnableOption "Neovim" // {default = true;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [inputs.rx-nvim.homeModules.default];
      programs.rx-nvim.enable = true;
    };
  };
}
