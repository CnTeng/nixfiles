{ config, user, ... }:
let
  userEmail = "rxsnakepi@gmail.com";
in
{
  programs.git.enable = true;

  home-manager.users.${user} = {
    programs.git = {
      enable = true;
      userName = "CnTeng";
      inherit userEmail;
      signing = {
        key = "~/.ssh/id_ed25519_sk_rk_ybk5@sign";
        signByDefault = true;
      };
      extraConfig = {
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = config.sops.templates.allowed_signers.path;
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

      matchBlocks."gitea" = {
        hostname = "git.snakepi.xyz";
        user = "git";
        identityFile = [
          "~/.ssh/id_ed25519_sk_rk_ybk5@git"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@git"
        ];
      };
    };
  };

  sops.secrets.signing_key_pub = {
    owner = user;
    sopsFile = ./secrets.yaml;
  };

  sops.templates.allowed_signers = {
    owner = user;
    content = ''
      ${userEmail} ${config.sops.placeholder.signing_key_pub} 
    '';
  };
}
