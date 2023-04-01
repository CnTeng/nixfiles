pkgs: oldAttrs: {
  # Fix QQ tray in windows manager
  runtimeDependencies = oldAttrs.runtimeDependencies
    ++ [ pkgs.libappindicator ];
}
