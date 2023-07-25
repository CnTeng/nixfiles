{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.proxy;
in {
  options.shell'.proxy = {
    enable = mkEnableOption "System proxy" // {default = true;};
    git = mkEnableOption "Git proxy" // {default = cfg.enable;};
  };

  config = mkIf cfg.enable {
    networking.proxy.default = "http://127.0.0.1:10808";

    home-manager.users.${user} = {
      programs = mkIf cfg.git {
        git.extraConfig = {
          http.proxy = "http://127.0.0.1:10808";
          https.proxy = "http://127.0.0.1:10808";
        };
        ssh.matchBlocks."github.com" = {
          proxyCommand = "nc -v -x 127.0.0.1:10808 %h %p";
        };
      };
    };
  };
}
