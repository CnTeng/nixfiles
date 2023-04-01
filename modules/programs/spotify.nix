{ config, lib, inputs, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.spotify;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  options.programs'.spotify.enable = mkEnableOption "Spotify";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [ inputs.spicetify-nix.homeManagerModule ];

      programs.spicetify = {
        enable = true;
        windowManagerPatch = true;
        theme = spicePkgs.themes.catppuccin-macchiato;
        colorScheme = "blue";

        enabledExtensions = with spicePkgs.extensions; [
          copyToClipboard
          keyboardShortcut
          volumePercentage
        ];
        enabledCustomApps = with spicePkgs.apps; [ lyrics-plus new-releases ];
      };

      xdg.desktopEntries = {
        spotify = {
          name = "Spotify";
          exec = "spotifywm";
          icon = "spotify";
          type = "Application";
        };
      };
    };
  };
}
