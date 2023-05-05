{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.bat;
in {
  options.shell'.bat = {
    enable = mkEnableOption "bat" // {default = true;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;
        config = {theme = "Catppuccin-macchiato";};
        themes = mapAttrs' (name: _:
          nameValuePair ("Catppuccin-" + name) (builtins.readFile
            (pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "bat";
                rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
                sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
              }
              + "/Catppuccin-${name}.tmTheme"))) {
          frappe = "frappe";
          latte = "latte";
          macchiato = "macchiato";
          mocha = "mocha";
        };
      };
    };
  };
}
