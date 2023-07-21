{
  config,
  lib,
  user,
  sources,
  ...
}:
with lib; let
  cfg = config.shell'.zsh;
  themeSrc = sources.catppuccin-zsh.src;
in {
  options.shell'.zsh.enable = mkEnableOption "zsh" // {default = true;};

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    home-manager.users.${user} = {
      programs.zsh = {
        enable = true;
        autocd = true;
        dotDir = ".config/zsh";
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "viins";
        initExtraFirst = ''
          source ${themeSrc}/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
        '';
      };
    };
  };
}
