{
  config,
  inputs,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.hardware'.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.hardware'.impermanence.enable = mkEnableOption "Impermanence";

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/home"
        "/var"
        "/etc/nix"
        {
          directory = "/etc/secureboot";
          user = "root";
          group = "root";
          mode = "u=rwx,g=rx,o=rx";
        }
      ];
      files = ["/etc/machine-id" "/etc/ssh/id_ed25519" "/etc/ssh/id_ed25519.pub"];
      users.${user} = {
        directories = [
          "Code"
          "Documents"
          "Downloads"
          "Pictures"
          "Projects"
          ".cache"
          ".local"
          ".mozilla"
          ".ssh"
          ".thunderbird"
          ".config"
        ];
      };
    };
  };
}
