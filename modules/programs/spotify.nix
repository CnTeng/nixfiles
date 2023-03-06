{ pkgs, inputs, system, user, ... }:

let spicePkgs = inputs.spicetify-nix.packages.${system}.default;
in {
  home-manager.users.${user} = {
    imports = [ inputs.spicetify-nix.homeManagerModule ];

    programs.spicetify = {
      enable = true;
      spotifyPackage = pkgs.spotifywm;
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
}
