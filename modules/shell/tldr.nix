{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.tldr;
in {
  options.shell'.tldr = {
    enable = mkEnableOption "tldr" // {default = true;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {programs.tealdeer.enable = true;};
  };
}
