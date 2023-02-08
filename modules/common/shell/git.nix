{ config, pkgs, user, ... }:

let
  homeDirectory = config.home-manager.users.${user}.home.homeDirectory;
  colorScheme = import ../../desktop/modules/colorscheme.nix;
in
{
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
      };
    };

    programs.ssh.matchBlocks = {
      "github.com" = {
        hostname = "ssh.github.com";
        user = "git";
        port = 443;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = [
          "${homeDirectory}/.ssh/id_ed25519_sk_rk_auth@Github"
        ];
      };
    };

    home.packages = with pkgs;[
      gh
      commitizen
    ];
  };
}
