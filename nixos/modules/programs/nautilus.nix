{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.nautilus;
in
{
  options.programs'.nautilus.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnome.nautilus ];
    environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
    environment.pathsToLink = [ "/share/nautilus-python/extensions" ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };
}
