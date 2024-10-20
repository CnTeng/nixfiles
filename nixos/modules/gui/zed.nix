{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.zed;
in
{
  options.gui'.zed.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zed-editor = {
        enable = true;
        userSettings = {
          theme = {
            mode = "system";
            light = "Adwaita Pastel Light";
            dark = "Adwaita Pastel Dark";
          };
          vim_mode = true;
        };
        extensions = [
          "adwaita-pastel"
          "nix"
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/zed"
        ".local/share/zed"
      ];
    };
  };
}
