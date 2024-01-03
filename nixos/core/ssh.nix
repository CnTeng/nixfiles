{ config, lib, user, ... }:
with lib;
let
  cfg = config.core'.ssh;

  inherit (config.hardware') persist;
in {
  options.core'.ssh.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    sops.secrets = {
      rxhc0-ipv4 = {
        key = "outputs/hosts/value/rxhc0/ipv4";
        owner = user;
        sopsFile = config.sops-file.infra;
      };
      rxls0-ipv4 = {
        key = "outputs/hosts/value/rxls0/ipv4";
        owner = user;
        sopsFile = config.sops-file.infra;
      };
    };

    sops.templates.ssh-config = let
      mkHost = name:
        let ip = config.sops.placeholder."${name}-ipv4";
        in ''
          Host ${name}
            HostName ${ip}
        '';
    in {
      content = mkHost "rxhc0" + mkHost "rxls0";
      owner = user;
    };

    home-manager.users.${user} = {
      services.ssh-agent.enable = true;

      programs.ssh = {
        enable = true;
        forwardAgent = true;
        includes = [ config.sops.templates.ssh-config.path ];
        matchBlocks = let
          defaultConfig = {
            inherit user;
            identityFile = [
              "~/.ssh/id_ed25519_sk_rk_auth@NixOS"
              "~/.ssh/id_ed25519_sk_backup@NixOS"
            ];
          };
        in {
          rxhc0 = defaultConfig;
          rxls0 = defaultConfig;
        };
      };
    };

    environment.persistence."/persist" =
      lib.mkIf persist.enable { users.${user}.directories = [ ".ssh" ]; };
  };
}
