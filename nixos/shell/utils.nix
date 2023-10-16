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

  catppuccin = pkgs.catppuccin.override {variant = flavour;};
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
      programs.bat = {
        enable = true;
        config.theme = "Catppuccin-${flavour}";
        themes."Catppuccin-${flavour}" = {
          src = catppuccin + /bat;
          file = "Catppuccin-${flavour}.tmTheme";
        };
      };

      xdg.configFile."btop/themes".source = catppuccin + /btop;
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "catppuccin_${flavour}.theme";
          theme_background = false;
          vim_keys = true;
        };
      };

      programs.tealdeer.enable = true;

      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      programs.zoxide.enable = true;

      home.packages = with pkgs; [
        wget
        tree
        neofetch
        scc
        gzip
        unrar
        unzipNLS
      ];
    };
  };
}
