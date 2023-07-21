{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.naive;
in {
  options.services'.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services'.caddy.enable;
        message = "caddy must be enabled to work with naive";
      }
    ];

    services.caddy.extraConfig = ''
      :443, ${config.networking.hostName}.snakepi.xyz {
      	log {
      		output file ${config.services.caddy.logDir}/naive.log
      	}

      	tls istengyf@outlook.com

        import ${config.age.secrets.naive.path}
      }
    '';

    age.secrets.naive = {
      file = ../../secrets/services/naive.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
