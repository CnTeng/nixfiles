{
  config,
  lib,
  sources,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.foot;
  # themeSrc = sources.catppuccin-alacritty.src;

  inherit (config.basics'.colors) flavour;
in {
  options.programs'.foot.enable = mkEnableOption "foot";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "FiraCode Nerd Font:12";
          };
        };
      };
    };
  };
}
