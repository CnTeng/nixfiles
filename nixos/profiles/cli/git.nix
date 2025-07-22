{ config, ... }:
let
  inherit (config.core') user;
in
{
  programs.git.enable = true;

  home-manager.users.${user} = {
    programs.git = {
      enable = true;
      userName = "CnTeng";
      userEmail = "rxsnakepi@gmail.com";
      signing = {
        key = "~/.ssh/id_ed25519_sk_rk_ybk5@sign";
        format = "ssh";
        signByDefault = true;
      };
      extraConfig = {
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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

    programs.ssh = {
      matchBlocks."github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        identityFile = [
          "~/.ssh/id_ed25519_sk_rk_ybk5@git"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@git"
        ];
      };

      matchBlocks."codeberg" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = [
          "~/.ssh/id_ed25519_sk_rk_ybk5@git"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@git"
        ];
      };
    };
  };
}
