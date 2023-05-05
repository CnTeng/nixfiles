{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.zsh;
  inherit (config.basics') colorScheme;
in {
  options.shell'.zsh.enable = mkEnableOption "zsh" // {default = true;};

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      histSize = 10000;
      autosuggestions = {
        enable = true;
        strategy = ["history" "completion"];
      };
      # Copy from https://github.com/catppuccin/zsh-syntax-highlighting
      syntaxHighlighting = {
        enable = true;
        highlighters = ["main" "cursor"];
        styles = {
          # Copy from https://github.com/catppuccin/zsh-syntax-highlighting
          "comment" = "fg=#${colorScheme.surface2}";
          "alias" = "fg=#${colorScheme.green}";
          "suffix-alias" = "fg=#${colorScheme.green}";
          "global-alias" = "fg=#${colorScheme.green}";
          "function" = "fg=#${colorScheme.green}";
          "command" = "fg=#${colorScheme.green}";
          "precommand" = "fg=#${colorScheme.green},italic";
          "autodirectory" = "fg=#${colorScheme.peach},italic";
          "single-hyphen-option" = "fg=#${colorScheme.peach}";
          "double-hyphen-option" = "fg=#${colorScheme.peach}";
          "back-quoted-argument" = "fg=#${colorScheme.mauve}";
          "builtin" = "fg=#${colorScheme.green}";
          "reserved-word" = "fg=#${colorScheme.green}";
          "hashed-command" = "fg=#${colorScheme.green}";
          "commandseparator" = "fg=#${colorScheme.red}";
          "command-substitution-delimiter" = "fg=#${colorScheme.text}";
          "command-substitution-delimiter-unquoted" = "fg=#${colorScheme.text}";
          "process-substitution-delimiter" = "fg=#${colorScheme.text}";
          "back-quoted-argument-delimiter" = "fg=#${colorScheme.red}";
          "back-double-quoted-argument" = "fg=#${colorScheme.red}";
          "back-dollar-quoted-argument" = "fg=#${colorScheme.red}";
          "command-substitution-quoted" = "fg=#${colorScheme.yellow}";
          "command-substitution-delimiter-quoted" = "fg=#${colorScheme.yellow}";
          "single-quoted-argument" = "fg=#${colorScheme.yellow}";
          "single-quoted-argument-unclosed" = "fg=#${colorScheme.maroon}";
          "double-quoted-argument" = "fg=#${colorScheme.yellow}";
          "double-quoted-argument-unclosed" = "fg=#${colorScheme.maroon}";
          "rc-quote" = "fg=#${colorScheme.yellow}";
          "dollar-quoted-argument" = "fg=#${colorScheme.text}";
          "dollar-quoted-argument-unclosed" = "fg=#${colorScheme.maroon}";
          "dollar-double-quoted-argument" = "fg=#${colorScheme.text}";
          "assign" = "fg=#${colorScheme.text}";
          "named-fd" = "fg=#${colorScheme.text}";
          "numeric-fd" = "fg=#${colorScheme.text}";
          "unknown-token" = "fg=#${colorScheme.maroon}";
          "path" = "fg=#${colorScheme.text},underline";
          "path_pathseparator" = "fg=#${colorScheme.red},underline";
          "path_prefix" = "fg=#${colorScheme.text},underline";
          "path_prefix_pathseparator" = "fg=#${colorScheme.red},underline";
          "globbing" = "fg=#${colorScheme.text}";
          "history-expansion" = "fg=#${colorScheme.mauve}";
          "back-quoted-argument-unclosed" = "fg=#${colorScheme.maroon}";
          "redirection" = "fg=#${colorScheme.text}";
          "arg0" = "fg=#${colorScheme.text}";
          "default" = "fg=#${colorScheme.text}";
          "cursor" = "fg=#${colorScheme.text}";
        };
      };
    };

    home-manager.users.${user} = {
      programs.zsh = {
        enable = true;
        defaultKeymap = "viins";
      };
    };
  };
}
