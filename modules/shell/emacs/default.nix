{ config, lib, pkgs, inputs, user, ... }:

with lib;

let cfg = config.shell'.emacs;
in {
  options.shell'.emacs = {
    enable = mkEnableOption "emacs" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      imports = [ inputs.nix-doom-emacs.hmModule ];
      programs.doom-emacs = {
        enable = true;
        doomPrivateDir = ./doom.d;
        emacsPackage = pkgs.emacsPgtk;
      };
    };
  };
}
