{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.bash;
in {
  options.shell'.bash.enable =
    mkEnableOption "bash" // {default = true;};

  config = mkIf cfg.enable {
    programs.bash.blesh.enable = true;

    home-manager.users.${user} = {
      programs.bash.enable = true;
    };
  };
}
