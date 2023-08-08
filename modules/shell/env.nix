{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.environment;
  lang = cfg.languages;
in {
  options.shell'.environment = {
    enable = mkEnableOption "All languages support" // {default = true;};
    languages = mapAttrs (_: doc:
      mkEnableOption (mkDoc doc)
      // {default = cfg.enable;}) {
      cpp = "C++ support";
      go = "Go support";
      haskell = "Haskell support";
      js = "Javascript support";
      nix = "Nix support";
      python = "Python support";
      rust = "Rust support";
    };
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = ["/share/fish"];

    programs = mkIf lang.nix {
      nix-ld.enable = true;

      # Use nix-index instead of cnf
      command-not-found.enable = false;
      nix-index.enable = true;
    };

    home-manager.users.${user} = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = mkIf lang.nix true;
      };
      programs.go = mkIf lang.go {
        enable = true;
        goPath = "go";
      };

      home.packages = with pkgs;
        optionals lang.cpp [gcc gdb gnumake cmake]
        ++ optionals lang.rust [rustc cargo]
        ++ optionals lang.js [nodejs]
        ++ optionals lang.haskell [ghc]
        ++ optionals lang.python
        [(pkgs.python3.withPackages (ps: with ps; [pip ipython]))];
    };
  };
}
