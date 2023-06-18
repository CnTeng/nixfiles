{ config, lib, sources, ... }:
with lib;
let
  cfg = config.shell'.starship;
  themeSrc = sources.catppuccin-starship.src;
in {
  options.shell'.starship.enable = mkEnableOption "starship" // {
    default = true;
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = let flavour = "macchiato";
      in {
        format = lib.concatStrings [
          "[\\[](bold blue)"
          "$username"
          "[@](bold red)"
          "$nix_shell"
          "$hostname[\\]](bold blue) "
          "$character"
          "$directory"
          "$git_branch"
          "$git_status"
        ];

        palette = "catppuccin_${flavour}";
        command_timeout = 3000;
        add_newline = false;

        username = {
          style_user = "bold white";
          style_root = "bold red";
          format = "[$user]($style)";
          disabled = false;
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          ssh_symbol = "";
          format = "[$ssh_symbol$hostname]($style)";
          style = "bold white";
        };

        character = {
          format = "$symbol ";
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
          vicmd_symbol = "[n](bold green)";
          vimcmd_replace_one_symbol = "[r](bold purple)";
          vimcmd_replace_symbol = "[r](bold purple)";
          vimcmd_visual_symbol = "[v](bold yellow)";
        };

        directory = {
          truncation_length = 1;
          format = "[$path]($style)[$read_only]($read_only_style) ";
          home_symbol = "~";
        };

        git_branch = {
          format = "(\\((bold)[$symbol$branch]($style)\\)(bold) )";
        };

        git_status = { format = "([$all_status$ahead_behind]($style) )"; };

        nix_shell = { format = "❄️"; };
      } // (with builtins;
        fromTOML (readFile (themeSrc + /palettes/${flavour}.toml)));
    };
  };
}
