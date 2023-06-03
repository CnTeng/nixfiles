let
  fileNames = with builtins;
    map (n: ./${n}) (filter (n: n != "default.nix" && n != "lib.nix")
      (attrNames (readDir ./.)));
in {imports = fileNames;}
