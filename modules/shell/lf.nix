{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.lf;
in {
  options.shell'.lf.enable = mkEnableOption "lf" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [pkgs.ctpv];
      programs.lf = {
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
