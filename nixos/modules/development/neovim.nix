{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.development'.neovim;
in
{
  imports = [ inputs.rx-nvim.nixosModules.default ];

  options.development'.neovim = {
    enable = lib.mkEnableOption "";
    withExtraPackages = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    programs.rx-nvim = {
      enable = true;
      defaultEditor = true;
      withExtraPackages = cfg.withExtraPackages;
    };

    preservation'.user.directories = [
      ".config/github-copilot"
      ".local/share/nvim"
      ".local/state/nvim"
      ".cache/nvim"
    ];
  };
}
