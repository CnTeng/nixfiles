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
        theme = spicePkgs.themes.catppuccin-macchiato;
        colorScheme = "blue";

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
