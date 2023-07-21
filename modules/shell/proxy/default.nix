{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.proxy;
in {
  imports = [./naive.nix ./v2ray.nix];

  options.shell'.proxy = {
    enable = mkEnableOption "System proxy" // {default = true;};
    cargo = mkEnableOption "Cargo proxy" // {default = cfg.enable;};
    git = mkEnableOption "Git proxy" // {default = cfg.enable;};
  };

  config = mkIf cfg.enable {
    networking.proxy.default = "http://127.0.0.1:10809";

    home-manager.users.${user} = {
      home.file.".cargo/config.toml".text = mkIf cfg.cargo ''
        [http]
        proxy = "http://127.0.0.1:10809"
      '';

      programs = mkIf cfg.git {
        git.extraConfig = {
          http.proxy = "http://127.0.0.1:10809";
          https.proxy = "http://127.0.0.1:10809";
        };
        ssh.matchBlocks."github.com" = {
          proxyCommand = "nc -v -x 127.0.0.1:10808 %h %p";
        };
      };
    };
  };
}
