{
  config,
  lib,
  pkgs,
  user,
  sources,
  ...
}:
with lib; let
  cfg = config.shell'.bat;
  inherit (config.basics'.colors) flavour;
in {
  options.shell'.bat.enable = mkEnableOption "bat" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;
        config = {theme = "Catppuccin-${toLower flavour}";};
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
        themes = let
          name = toLower flavour;
          inherit (sources.catppuccin-bat) src;
        in {
          "Catppuccin-${name}" = builtins.readFile (src + /Catppuccin-${name}.tmTheme);
        };
      };
    };
  };
}
