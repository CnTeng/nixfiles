{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.git;

  flavour = toLower config.core'.colors.flavour;
in
{
  options.utils'.git.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.git = {
        enable = true;
        userName = "CnTeng";
        userEmail = "me@snakepi.xyz";
        signing = {
          key = "24161031945F3E02!";
          signByDefault = true;
        };

        lfs.enable = true;

        delta = {
          enable = true;
          options = {
            dark = true;
            line-numbers = true;
            syntax-theme = "Catppuccin-${flavour}";
          };
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          gui.theme = {
            lightTheme = false;
          };
        };
      };

      programs.ssh.matchBlocks."github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        identityFile = [
          "~/.ssh/id_ed25519_sk_rk_auth@Github"
          "~/.ssh/id_ed25519_sk_backup@Github"
        ];
      };
    };
  };
}
