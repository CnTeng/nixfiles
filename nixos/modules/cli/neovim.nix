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
    enable = lib.mkEnableOption' { };
    withExtraPackages = lib.mkEnableOption' { };
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

    environment.persistence."/persist" = {
      users.${user}.directories =
        [
          ".local/share/nvim"
          ".local/state/nvim"
          ".cache/nvim"
          ".config/github-copilot"
        ]
        ++ (lib.optionalAttrs cfg.withExtraPackages [
          ".local/share/go"
        ]);
    };
  };
}
