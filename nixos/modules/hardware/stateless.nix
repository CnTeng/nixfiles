{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.hardware'.stateless;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware'.stateless.enable = mkEnableOption' { };

  config = mkMerge [
    { environment.persistence."/persist".enable = mkDefault false; }
    (mkIf cfg.enable {

      sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

      boot.tmp.useTmpfs = true;

      environment.systemPackages = [ pkgs.persist ];

      environment.persistence."/persist" = {
        enable = true;
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
      };
    })
  ];
}
