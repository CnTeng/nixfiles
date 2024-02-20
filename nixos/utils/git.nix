{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.git;
in
{
  options.utils'.git.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        programs.git = {
          enable = true;
          userName = "CnTeng";
          userEmail = "rxsnakepi@gmail.com";
          signing = {
            key = "/home/yufei/.ssh/id_ed25519_yufei";
            signByDefault = true;
          };
          extraConfig = {
            gpg = {
              format = "ssh";
              ssh.allowedSignersFile = builtins.toFile "allowed_signers" ''
                ${config.programs.git.userEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS5DHfxuhsH2yg1woBz1xTsRLDy+eZXgkGxYXJlYi91 yufei
              '';
            };
          };

          lfs.enable = true;

          delta = {
            enable = true;
            options = {
              dark = true;
              line-numbers = true;
            };
          };
        };

        programs.lazygit = {
          enable = true;
          settings = {
            gui.nerdFontsVersion = "3";
          };
        };

        programs.ssh.matchBlocks."github.com" = {
          hostname = "ssh.github.com";
          port = 443;
          user = "git";
          identityFile = [
            "~/.ssh/id_ed25519_sk_rk_git"
            "~/.ssh/id_ed25519_sk_git"
          ];
        };
      };
  };
}
