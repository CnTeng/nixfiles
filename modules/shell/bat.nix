{ config, lib, pkgs, user, sources, ... }:
with lib;
let cfg = config.shell'.bat;
in {
  options.shell'.bat.enable = mkEnableOption "bat" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;
        config = { theme = "Catppuccin-macchiato"; };
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
        themes = mapAttrs' (name: _:
          nameValuePair ("Catppuccin-" + name) (builtins.readFile
            (sources.catppuccin-bat.src + /Catppuccin-${name}.tmTheme))) {
              frappe = "frappe";
              latte = "latte";
              macchiato = "macchiato";
              mocha = "mocha";
            };
      };
    };
  };
}
