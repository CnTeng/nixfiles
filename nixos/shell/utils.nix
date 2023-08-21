{
  inputs,
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.shell'.utils;
  inherit (inputs.catppuccin) btopCat batCat;
  inherit (config.basics'.colors) flavour;
  inherit (config.home-manager.users.${user}.xdg) configHome;
in {
  options.shell'.utils = {
    enable = mkEnableOption "shell utils" // {default = true;};
    modules = mapAttrs (_: doc:
      mkEnableOption (mkDoc doc)
      // {default = cfg.enable;}) {
      bat = "bat";
      btop = "btop";
      fzf = "fzf";
      hyfetch = "hyfetch";
      lf = "lf";
      tealdeer = "tealdeer";
      others = "others";
      zoxide = "zoxide";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = mkIf cfg.modules.bat {
        enable = true;
        config = {theme = "Catppuccin-${toLower flavour}";};
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
        themes = let
          name = toLower flavour;
        in {
          "Catppuccin-${name}" = builtins.readFile (batCat + /Catppuccin-${name}.tmTheme);
        };
      };

      programs.btop = mkIf cfg.modules.btop {
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
      xdg.configFile."btop/themes".source = btopCat + /themes;

      programs.hyfetch = mkIf cfg.modules.hyfetch {
        enable = true;
        settings = {
          preset = "rainbow";
          mode = "rgb";
          color_align = {mode = "horizontal";};
        };
      };

      programs.tealdeer.enable = mkIf cfg.modules.tealdeer true;

      programs.zoxide.enable = mkIf cfg.modules.zoxide true;

      home.packages = with pkgs; mkIf cfg.modules.others [unzipNLS gzip unrar wget fd usbutils ctpv];

      programs.fzf.enable = mkIf cfg.modules.fzf true;

      programs.lf = mkIf cfg.modules.lf {
        enable = true;
        settings = {icons = true;};
        extraConfig = ''
          set previewer ctpv
          set cleaner ctpvclear
          &ctpv -s $id
          &ctpvquit $id
        '';
      };
      xdg.configFile = {
        "lf/colors".source = "${pkgs.lf.src}/etc/colors.example";
        "lf/icons".source = "${pkgs.lf.src}/etc/icons.example";
      };
    };
  };
}
