{ config, lib, inputs, user, ... }:
with lib;
let cfg = config.basics'.security;
in {
  imports = [ inputs.sops-nix.nixosModules.default ];

  options.basics'.security.enable = mkEnableOption "security config" // {
    default = true;
  };

  config = mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;
    security.tpm2.enable = true;

    sops.age.sshKeyPaths = mkIf config.hardware'.persist.enable
      [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    programs.gnupg.agent.enable = true;

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = [ ".gnupg" ];
    };
  };
}
