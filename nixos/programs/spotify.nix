{ config, lib, inputs, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.spotify;
  spicePkgs = inputs.spicetify.packages.${pkgs.system}.default;

  inherit (config.core'.colors) flavour;
in {
  options.programs'.spotify.enable = mkEnableOption "Spotify";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [ inputs.spicetify.homeManagerModule ];

      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = toLower flavour;

        enabledExtensions = with spicePkgs.extensions; [
          copyToClipboard
          keyboardShortcut
          volumePercentage
        ];

        enabledCustomApps = with spicePkgs.apps; [ new-releases ];
      };
    };
  };
}
