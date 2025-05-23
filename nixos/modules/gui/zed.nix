{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.zed;
in
{
  options.gui'.zed.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zed-editor = {
        enable = true;
        userSettings = {
          theme = {
            mode = "system";
            light = "Adwaita Pastel Light";
            dark = "Adwaita Pastel Dark";
          };

          features.edit_prediction_provider = "copilot";

          buffer_font_family = "FiraCode Nerd Font";
          buffer_font_fallbacks = [ "Noto Sans CJK SC" ];
          buffer_font_size = 14;
          ui_font_family = "Adwaita Sans";
          ui_font_fallbacks = [
            "Noto Sans CJK SC"
            "FiraCode Nerd Font"
          ];

          vim_mode = true;

          inlay_hints.enabled = true;
          diagnostics.inline.enabled = true;

          assistant = {
            version = "2";
            default_model = {
              provider = "copilot_chat";
              model = "claude-3-7-sonnet";
            };
            editor_model = {
              provider = "copilot_chat";
              model = "claude-3-7-sonnet";
            };
          };

          tab_size = 2;

          lsp = {
            clangd.binary = {
              path = "clangd";
              arguments = [
                "--background-index"
                "--clang-tidy"
                "--completion-style=detailed"
                "--function-arg-placeholders"
                "--header-insertion=iwyu"
              ];
            };
          };

          vim.toggle_relative_line_numbers = true;

          ssh_connections = [
            { host = "kylin"; }
          ];
        };
        userKeymaps = [
          {
            bindings = {
              ctrl-q = null;
              "ctrl-[" = [
                "workspace::SendKeystrokes"
                "escape"
              ];
            };
          }

          {
            context = "EmptyPane || SharedScreen || (Dock > !Pane) || (Editor && vim_mode == normal)";
            bindings = {
              ctrl-h = "workspace::ActivatePaneLeft";
              ctrl-l = "workspace::ActivatePaneRight";
              ctrl-k = "workspace::ActivatePaneUp";
              ctrl-j = "workspace::ActivatePaneDown";
              ctrl-q = "pane::CloseActiveItem";

              "ctrl-\\" = "workspace::ToggleBottomDock";
              "space e" = "workspace::ToggleLeftDock";
              "space a a" = "workspace::ToggleRightDock";
            };
          }

          {
            context = "Terminal";
            bindings = {
              ctrl-h = "workspace::ActivatePaneLeft";
              ctrl-l = "workspace::ActivatePaneRight";
              ctrl-k = "workspace::ActivatePaneUp";
              ctrl-j = "workspace::ActivatePaneDown";
              ctrl-q = "pane::CloseActiveItem";
            };
          }

          {
            context = "ProjectPanel && not_editing";
            bindings = {
              ctrl-q = "workspace::ToggleLeftDock";

              a = "project_panel::NewFile";
              d = "project_panel::Delete";
              l = "project_panel::OpenPermanent";
              p = "project_panel::Paste";
              r = "project_panel::Rename";
              x = "project_panel::Cut";
              y = "project_panel::Copy";
            };
          }

          {
            context = "VimControl && !menu";
            bindings = {
              # Lsp
              "space l a" = "editor::ToggleCodeActions";
              "space l f" = "editor::Format";
              "space l r" = "editor::Rename";
            };
          }

          {
            context = "vim_mode == normal && !menu";
            bindings = {
              # Buffer
              shift-h = "pane::ActivatePreviousItem";
              shift-l = "pane::ActivateNextItem";
              "space b" = "tab_switcher::Toggle";

              # Finder
              "space f f" = "file_finder::Toggle";
              "space f w" = "pane::DeploySearch";

              # Lsp
              "g r" = "editor::FindAllReferences";
              "space l d" = "diagnostics::Deploy";
              "space l o" = "outline::Toggle";
              "space c s" = "editor::SwitchSourceHeader";
            };
          }

          {
            context = "vim_mode == visual && !menu";
            bindings = {
              shift-j = "editor::MoveLineDown";
              shift-k = "editor::MoveLineUp";
            };
          }

          {
            context = "Editor && edit_prediction";
            bindings = {
              ctrl-j = "editor::AcceptEditPrediction";
            };
          }
        ];
        extensions = [
          "adwaita-pastel"
          "git-firefly"
          "make"
          "neocmake"
          "nix"
        ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/zed"
        ".local/share/zed"
      ];
    };
  };
}
