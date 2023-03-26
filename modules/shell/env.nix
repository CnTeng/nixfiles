{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.custom.shell.environment;
  lang = cfg.languages;
in {
  options.custom.shell.environment = {
    enable = mkEnableOption "All languages support" // { default = true; };
    languages = mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // { default = cfg.enable; }) {
        cpp = "C++ support";
        rust = "Rust support";
        go = "Go support";
        nix = "Nix support";
        js = "Javascript support";
        python = "Python support";
      };
  };

  config = mkIf cfg.enable {
    programs = mkIf lang.nix {
      nix-ld.enable = true;

      # Use nix-index instead of cnf
      command-not-found.enable = false;
      nix-index.enable = true;
    };

    home-manager.users.${user} = {
      programs.go = mkIf lang.go {
        enable = true;
        goPath = "go";
      };

      home.packages = with pkgs;
        optionals lang.cpp [ gcc gdb gnumake cmake ]
        ++ optionals lang.rust [ rustc cargo ] ++ optionals lang.js [ nodejs ]
        ++ optionals lang.python
        [ (pkgs.python3.withPackages (ps: with ps; [ pip ipython ])) ];
    };
  };
}
