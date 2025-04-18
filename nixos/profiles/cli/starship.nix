{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.starship ];

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "([\\[](bold blue)"
        "$username"
        "[@](bold red)"
        "$hostname"
        "[\\]](bold blue) )"
        "$character"
      ];

      command_timeout = 3000;
      add_newline = false;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[n](bold green)";
        vimcmd_replace_one_symbol = "[r](bold purple)";
        vimcmd_replace_symbol = "[r](bold purple)";
        vimcmd_visual_symbol = "[v](bold yellow)";
      };

      cmd_duration.format = "[󱐋 $duration]($style) ";

      directory.fish_style_pwd_dir_length = 1;

      fill.symbol = " ";

      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";

      git_commit.format = "[$hash$tag]($style) ";

      git_state.format = "[$state( $progress_current/$progress_total) ]($style) ";

      git_status.deleted = "x";

      hostname = {
        format = "[$hostname]($style)";
        style = "bold white";
      };

      nix_shell = {
        format = "[$symbol$name]($style)";
        symbol = " ";
      };

      username = {
        style_user = "bold white";
        format = "[$user]($style)";
      };
    };
  };
}
