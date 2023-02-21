{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev:
    let
      pkgs = final.pkgs;

      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      waybarPatchFile = import ./waybar.nix { inherit pkgs hyprctl; };
    in
    {
      # Add wlr/workspace click support for hyprland
      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
      });

      # Use spotifywm as spotify exec
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

      # Fix qq tray
      qq = prev.qq.overrideAttrs (oldAttrs: {
        runtimeDependencies = oldAttrs.runtimeDependencies ++ [ pkgs.libappindicator ];
      });
    };
}
