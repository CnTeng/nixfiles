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
  imports = [ inputs.preservation.nixosModules.default ];

  options.hardware'.stateless.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    boot.tmp.useTmpfs = true;

    sops.age.keyFile = lib.mkForce "/persist/var/lib/sops-nix/key";

    environment.systemPackages = [ pkgs.persist ];

    preservation = {
      enable = true;
      preserveAt."/persist" = {
        directories = [
          "/var/cache"
          {
            directory = "/var/log";
            inInitrd = true;
          }
          {
            directory = "/var/lib";
            inInitrd = true;
          }
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
        users.${user}.directories = [
          ".cache/nix"
          ".cache/pre-commit"
          ".cache/treefmt"
          ".local/share/direnv"
          ".local/share/nix"
          ".local/state/nix"
        ];
      };
    };

    systemd.tmpfiles.settings.preservation = {
      "/home/${user}/.cache".d = {
        inherit user;
        group = "users";
        mode = "0755";
      };
      "/home/${user}/.config".d = {
        inherit user;
        group = "users";
        mode = "0755";
      };
      "/home/${user}/.local".d = {
        inherit user;
        group = "users";
        mode = "0755";
      };
      "/home/${user}/.local/share".d = {
        inherit user;
        group = "users";
        mode = "0755";
      };
      "/home/${user}/.local/state".d = {
        inherit user;
        group = "users";
        mode = "0755";
      };
    };
  };
}
