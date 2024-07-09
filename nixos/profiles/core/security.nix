{
  config,
  pkgs,
  user,
  ...
}:
{
  sops.secrets.yubikey = {
    sopsFile = ./secrets.yaml;
    mode = "0444";
  };

  security.pam.services.sudo =
    { config, ... }:
    {
      rules.auth.rssh = {
        order = config.rules.auth.unix.order - 10;
        control = "sufficient";
        modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
        settings.auth_key_file = "/etc/ssh/authorized_keys.d/${user}";
      };
    };

  security.pam.u2f = {
    enable = true;
    settings = {
      authfile = config.sops.secrets.yubikey.path;
      appid = "pam://nixos";
      origin = "pam://nixos";
      cue = true;
    };
  };

  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
  '';
}
