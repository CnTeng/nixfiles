{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.custom.shell.git;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
  inherit (config.custom) colorScheme;
in {
  options.custom.shell.git = {
    enable = mkEnableOption "git" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.git = {
        enable = true;
        userName = "CnTeng";
        userEmail = "istengyf@outlook.com";
      };

      programs.lazygit = {
        enable = true;
        settings = {
          gui.theme = {
            lightTheme = false;
            activeBorderColor = [ "#${colorScheme.green}" "bold" ];
            inactiveBorderColor = [ "#${colorScheme.text}" ];
            optionsTextColor = [ "#${colorScheme.blue}" ];
            selectedLineBgColor = [ "#${colorScheme.surface0}" ];
            selectedRangeBgColor = [ "#${colorScheme.surface0}" ];
            cherryPickedCommitBgColor = [ "#${colorScheme.teal}" ];
            cherryPickedCommitFgColor = [ "#${colorScheme.blue}" ];
            unstagedChangesColor = [ "#${colorScheme.red}" ];
          };
          customCommands = [{
            key = "C";
            command = "git cz c";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commitizen commit tool";
            subprocess = true;
          }];
        };
      };

      programs.ssh.matchBlocks = {
        "github.com" = {
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
          extraOptions.AddKeysToAgent = "yes";
          identityFile =
            [ "${homeDirectory}/.ssh/id_ed25519_sk_rk_auth@Github" ];
        };
      };

      home.packages = with pkgs; [ gh commitizen ];
    };
  };
}
