{ user, ... }:

let
  colorScheme = import ../../desktop/modules/colorscheme.nix;
in
{
  programs.zsh = {
    enable = true;
    histSize = 10000;
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    # Copy from https://github.com/catppuccin/zsh-syntax-highlighting
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "cursor" ];
      styles = {
        # Copy from https://github.com/catppuccin/zsh-syntax-highlighting
        "comment" = "fg=#${colorScheme.base04}";
        "alias" = "fg=#${colorScheme.base0B}";
        "suffix-alias" = "fg=#${colorScheme.base0B}";
        "global-alias" = "fg=#${colorScheme.base0B}";
        "function" = "fg=#${colorScheme.base0B}";
        "command" = "fg=#${colorScheme.base0B}";
        "precommand" = "fg=#${colorScheme.base0B},italic";
        "autodirectory" = "fg=#${colorScheme.base09},italic";
        "single-hyphen-option" = "fg=#${colorScheme.base09}";
        "double-hyphen-option" = "fg=#${colorScheme.base09}";
        "back-quoted-argument" = "fg=#${colorScheme.base0E}";
        "builtin" = "fg=#${colorScheme.base0B}";
        "reserved-word" = "fg=#${colorScheme.base0B}";
        "hashed-command" = "fg=#${colorScheme.base0B}";
        "commandseparator" = "fg=#${colorScheme.base08}";
        "command-substitution-delimiter" = "fg=#${colorScheme.base05}";
        "command-substitution-delimiter-unquoted" = "fg=#${colorScheme.base05}";
        "process-substitution-delimiter" = "fg=#${colorScheme.base05}";
        "back-quoted-argument-delimiter" = "fg=#${colorScheme.base08}";
        "back-double-quoted-argument" = "fg=#${colorScheme.base08}";
        "back-dollar-quoted-argument" = "fg=#${colorScheme.base08}";
        "command-substitution-quoted" = "fg=#${colorScheme.base0A}";
        "command-substitution-delimiter-quoted" = "fg=#${colorScheme.base0A}";
        "single-quoted-argument" = "fg=#${colorScheme.base0A}";
        "single-quoted-argument-unclosed" = "fg=#ee99a0";
        "double-quoted-argument" = "fg=#${colorScheme.base0A}";
        "double-quoted-argument-unclosed" = "fg=#ee99a0";
        "rc-quote" = "fg=#${colorScheme.base0A}";
        "dollar-quoted-argument" = "fg=#${colorScheme.base05}";
        "dollar-quoted-argument-unclosed" = "fg=#ee99a0";
        "dollar-double-quoted-argument" = "fg=#${colorScheme.base05}";
        "assign" = "fg=#${colorScheme.base05}";
        "named-fd" = "fg=#${colorScheme.base05}";
        "numeric-fd" = "fg=#${colorScheme.base05}";
        "unknown-token" = "fg=#ee99a0";
        "path" = "fg=#${colorScheme.base05},underline";
        "path_pathseparator" = "fg=#${colorScheme.base08},underline";
        "path_prefix" = "fg=#${colorScheme.base05},underline";
        "path_prefix_pathseparator" = "fg=#${colorScheme.base08},underline";
        "globbing" = "fg=#${colorScheme.base05}";
        "history-expansion" = "fg=#${colorScheme.base0E}";
        "back-quoted-argument-unclosed" = "fg=#ee99a0";
        "redirection" = "fg=#${colorScheme.base05}";
        "arg0" = "fg=#${colorScheme.base05}";
        "default" = "fg=#${colorScheme.base05}";
        "cursor" = "fg=#${colorScheme.base05}";
      };
    };
  };

  home-manager.users.${user} = {
    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";
    };
  };

}
