{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev:
    let
      inherit (final) pkgs;

      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      waybarPatchFile = import ./waybar.nix { inherit pkgs hyprctl; };
    in {
      # Add wlr/workspace click support for hyprland
      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
      });

      # Fix qq tray
      qq = prev.qq.overrideAttrs (oldAttrs: {
        runtimeDependencies = oldAttrs.runtimeDependencies
          ++ [ pkgs.libappindicator ];
      });
    };
}
