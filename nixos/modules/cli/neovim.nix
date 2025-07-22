{
  inputs,
  lib,
  config,
  user,
  ...
}:
let
  cfg = config.cli'.neovim;
in
{
  imports = [ inputs.rx-nvim.nixosModules.default ];

  options.cli'.neovim = {
    enable = lib.mkEnableOption "";
    withExtraPackages = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    programs.rx-nvim = {
      enable = true;
      defaultEditor = true;
      withExtraPackages = cfg.withExtraPackages;
    };

    home-manager.users.${user} = {
      programs.go = {
        enable = cfg.withExtraPackages;
        goPath = ".local/share/go";
      };
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories =
        [
          ".config/github-copilot"
          ".local/share/nvim"
          ".local/state/nvim"
          ".cache/nvim"
        ]
        ++ (lib.optionals cfg.withExtraPackages [
          ".local/share/go"
        ]);
    };
  };
}
