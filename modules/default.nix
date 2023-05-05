{
  flake.nixosModules = {
    default = let
      fileNames = with builtins;
        map (n: ./${n})
        (filter (n: n != "default.nix") (attrNames (readDir ./.)));
    in {imports = fileNames;};
  };
}
