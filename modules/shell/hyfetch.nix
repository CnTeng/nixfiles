{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.hyfetch;
in {
  options.shell'.hyfetch.enable =
    mkEnableOption "hyfetch"
    // {
      default = true;
    };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.hyfetch = {
        enable = true;
        settings = {
          preset = "rainbow";
          mode = "rgb";
          color_align = {mode = "horizontal";};
        };
      };
    };
  };
}
