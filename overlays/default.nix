{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev:
    let
      pkgs = final.pkgs;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      waybarPatchFile = import ./waybar.nix { inherit pkgs hyprctl; };
    in
    {

      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
      });

      discord = prev.discord.override { nss = pkgs.nss_latest; };
    };
}
