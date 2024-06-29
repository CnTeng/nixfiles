{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.hardware'.stateless;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware'.stateless.enable = lib.mkEnableOption' { };

  config = lib.mkMerge [
    { environment.persistence."/persist".enable = lib.mkDefault false; }
    (lib.mkIf cfg.enable {
      boot.tmp.useTmpfs = true;

      sops.age.keyFile = lib.mkForce "/persist/var/lib/sops-nix/key";

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
