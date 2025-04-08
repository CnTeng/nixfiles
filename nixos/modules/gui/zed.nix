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

          buffer_font_family = "FiraCode Nerd Font";
          buffer_font_fallbacks = [ "Noto Sans CJK SC" ];
          buffer_font_size = 14;
          ui_font_family = "Noto Sans Mono";
          ui_font_fallbacks = [
            "Noto Sans CJK SC"
            "FiraCode Nerd Font"
          ];

          vim_mode = true;

          auto_signature_help = true;
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
            context = "Workspace";
            bindings = {
              ctrl-h = "workspace::ActivatePaneLeft";
              ctrl-l = "workspace::ActivatePaneRight";
              ctrl-k = "workspace::ActivatePaneUp";
              ctrl-j = "workspace::ActivatePaneDown";
            };
          }
          {
            context = "Editor && vim_mode == normal";
            bindings = {
              ctrl-h = "workspace::ActivatePaneLeft";
              ctrl-l = "workspace::ActivatePaneRight";
              ctrl-k = "workspace::ActivatePaneUp";
              ctrl-j = "workspace::ActivatePaneDown";

              "space l f" = "editor::Format";
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
