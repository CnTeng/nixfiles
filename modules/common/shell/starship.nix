{ lib, ... }:

# TODO:finsh starship
{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[\\[](bold blue)"
        "$username"
        "[@](bold red)"
        "$hostname[\\]](bold blue) "
        "$character"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
      ];
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
        ssh_symbol = "🌏";
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
      shell = {
        format = "[$indicator]($style)";
        fish_indicator = "";
        powershell_indicator = "_";
        disabled = false;
      };
      git_branch = {
        format = "(\\((bold)[$symbol$branch]($style)\\)(bold) )";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
      };
    };
  };
}
