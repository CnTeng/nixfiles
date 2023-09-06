{
  inputs,
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.utils;
  flavour = toLower config.basics'.colors.flavour;

  inherit (inputs.catppuccin) batTheme btopTheme;
in {
  imports = [inputs.nix-index-database.nixosModules.nix-index];

  options.shell'.utils.enable = mkEnableOption "shell utils" // {default = true;};

  config = mkIf cfg.enable {
    programs = {
      direnv.enable = true;

      command-not-found.enable = false;
      nix-index-database.comma.enable = true;
    };

    home-manager.users.${user} = {
      programs = {
        bat = {
          enable = true;
          config.theme = "Catppuccin-${flavour}";
          themes."Catppuccin-${flavour}" = builtins.readFile (
            batTheme + /Catppuccin-${flavour}.tmTheme
          );
        };

        btop = {
          enable = true;
          settings = {
            color_theme = "catppuccin_${flavour}.theme";
            theme_background = false;
            vim_keys = true;
          };
        };

        tealdeer.enable = true;
        yazi.enable = true;
        zoxide.enable = true;
      };

      home.packages = with pkgs; [
        wget
        tree
        neofetch
        scc
        gzip
        unrar
        unzipNLS
      ];

      xdg.configFile."btop/themes".source = btopTheme + /themes;
    };
  };
}
