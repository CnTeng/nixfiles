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

  flavour = toLower config.basics'.colors.flavour;
in {
  options.shell'.git.enable = mkEnableOption "git" // {default = true;};

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
