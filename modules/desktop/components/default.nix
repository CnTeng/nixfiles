let
  fileNames = with builtins;
    map (n: ./${n}) (filter (n: n != "default.nix" && n != "scripts")
      (attrNames (readDir ./.)));
in {imports = fileNames;}
