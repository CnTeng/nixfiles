{
  config,
  inputs,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.hardware'.persist;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware'.persist.enable = mkEnableOption' { };

  config = {
    sops.age.sshKeyPaths = mkIf cfg.enable [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    boot.tmp.useTmpfs = cfg.enable;

    environment.persistence."/persist" =
      if cfg.enable then
        {
          hideMounts = true;
          directories = [
            "/var/cache"
            "/var/lib"
            "/var/log"
          ];
          files = [ "/etc/machine-id" ];
          users.${user}.directories = [
            ".cache/nix"
            ".cache/pre-commit"
            ".cache/treefmt"
            ".local/share/direnv"
            ".local/share/nix"
            ".local/state/nix"
          ];
        }
      else
        mkForce { };
  };
}
