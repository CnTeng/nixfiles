{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.git;
  inherit (config.users.users.${user}) home;
in {
  options.shell'.git.enable = mkEnableOption "git" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.git = {
        lfs.enable = true;
        enable = true;
        userName = "CnTeng";
        userEmail = "me@snakepi.xyz";
        delta = {
          enable = true;
          options = {
            dark = true;
            line-numbers = true;
            syntax-theme = "Catppuccin-macchiato";
          };
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          gui.theme = {
            lightTheme = false;
          };
          customCommands = [
            {
              key = "C";
              command = "git cz c";
              description = "commit with commitizen";
              context = "files";
              loadingText = "opening commitizen commit tool";
              subprocess = true;
            }
          ];
        };
      };

      programs.ssh.matchBlocks = {
        "github.com" = {
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
          extraOptions.AddKeysToAgent = "yes";
          identityFile = ["${home}/.ssh/id_ed25519_sk_rk_auth@Github"];
        };
      };

      home.packages = with pkgs; [gh commitizen];
    };
  };
}
