{ config, inputs, lib, user, ... }:
with lib;
let cfg = config.hardware'.stateless;
in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware'.stateless.enable = mkEnableOption "persistent state";

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var"
        "/etc/nix"
        {
          directory = "/etc/secureboot";
          user = "root";
          group = "root";
          mode = "u=rwx,g=rx,o=rx";
        }
      ];
      files =
        [ "/etc/machine-id" "/etc/ssh/id_ed25519" "/etc/ssh/id_ed25519.pub" ];
      users.${user} = {
        directories =
          [ "Projects" ".cache" ".local" ".mozilla" ".ssh" ".config" ];
      };
    };
  };
}
