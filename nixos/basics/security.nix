{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.basics'.security;
in {
  imports = [inputs.sops-nix.nixosModules.default];

  options.basics'.security.enable =
    mkEnableOption "security config" // {default = true;};

  config = mkIf cfg.enable {
    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
      tpm2.enable = true;
    };

    sops.age.sshKeyPaths = mkIf config.hardware'.stateless.enable ["/persist/etc/ssh/ssh_host_ed25519_key"];
  };
}
