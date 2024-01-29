{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.core'.sops;
  inherit (config.hardware') persist;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  options.core'.sops.enable = mkEnableOption' { default = true; };

  options.sops-file.infra = mkOption {
    type = types.path;
    visible = false;
  };

  config = mkIf cfg.enable {
    sops-file.infra = ../../infra/tfstate.yaml;

    sops.age.sshKeyPaths = mkIf persist.enable [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
  };
}
