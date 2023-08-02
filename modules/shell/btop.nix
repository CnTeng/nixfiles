{
  config,
  lib,
  sources,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.btop;
  themeSrc = sources.catppuccin-btop.src;
  inherit (config.basics'.colors) flavour;
  inherit (config.home-manager.users.${user}.xdg) configHome;
in {
  options.shell'.btop.enable = mkEnableOption "btop" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = configHome + "/btop/themes/catppuccin_${toLower flavour}.theme";
          theme_background = false;
          vim_keys = true;
          shown_boxes = "proc cpu mem net";
          update_ms = 2000;
          proc_sorting = "cpu direct";
          use_fstab = true;
          net_sync = true;
        };
      };
      xdg.configFile."btop/themes".source = themeSrc + /themes;
    };
  };
}
