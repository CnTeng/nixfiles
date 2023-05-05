{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.task;
in {
  options.shell'.task = {
    enable = mkEnableOption "taskwarrior" // {default = true;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [taskwarrior-tui];
      programs.taskwarrior = {
        enable = true;
        colorTheme = "dark-gray-blue-256";
      };
    };
  };
}
