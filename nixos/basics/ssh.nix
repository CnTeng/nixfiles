{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.basics'.ssh;
  inherit (config.users.users.${user}) home;
in {
  options.basics'.ssh.enable =
    mkEnableOption "ssh config" // {default = true;};

  config = mkIf cfg.enable {
    sops.secrets = {
      "outputs/rxhc/value/rxhc0/ipv4" = {
        sopsFile = ../../infra/tfstate.yaml;
        mode = "0444";
      };
      "outputs/rxls/value/rxls0/ipv4" = {
        sopsFile = ../../infra/tfstate.yaml;
        mode = "0444";
      };
    };

    sops.templates.ssh-config = let
      mkBlock = host: ip: ''
        Host ${host}
          User yufei
          HostName ${ip}
          IdentityFile ${home}/.ssh/id_ed25519_sk_rk_auth@NixOS
      '';
    in {
      content =
        mkBlock "rxhc0" config.sops.placeholder."outputs/rxhc/value/rxhc0/ipv4"
        + mkBlock "rxls0" config.sops.placeholder."outputs/rxls/value/rxls0/ipv4";
      mode = "0444";
    };

    programs.ssh = {
      startAgent = true;
      extraConfig = "Include ${config.sops.templates.ssh-config.path}";
    };
  };
}
