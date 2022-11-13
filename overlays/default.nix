{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev:
    let
      pkgs = final.pkgs;
      fetchFromGitHub = final.fetchFromGitHub;

      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      waybarPatchFile = import ./waybar.nix { inherit pkgs hyprctl; };
    in
    {

      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
      });

      discord = prev.discord.override { nss = pkgs.nss_latest; };

      spotifywm = prev.spotifywm.overrideAttrs (oldAttrs: {
        version = "2022-10-26";
        src = fetchFromGitHub {
          owner = "dasJ";
          repo = "spotifywm";
          rev = "8624f539549973c124ed18753881045968881745";
          sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
        };
      });

      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        installPhase = builtins.replaceStrings
          [
            ''
              sed -i "s:^Icon=.*:Icon=spotify-client:" "$out/share/spotify/spotify.desktop"
            ''
          ]
          [
            ''
              sed -i "s:^Icon=.*:Icon=spotify-client:" "$out/share/spotify/spotify.desktop"
              sed -i "s:^Exec=.*:Exec=spotifywm %U:" "$out/share/spotify/spotify.desktop"
              sed -i "s:^TryExec=.*:Exec=spotifywm:" "$out/share/spotify/spotify.desktop"
            ''
          ]
          oldAttrs.installPhase;
      });
    };
}
