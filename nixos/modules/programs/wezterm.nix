{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.wezterm;

  luaFormat = lib.generators.toLua { };
  inherit (lib.generators) mkLuaInline;
in
{
  options.programs'.wezterm.enable = mkEnableOption "wezterm";

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      users.${user}.directories = [ ".local/share/wezterm" ];
    };

    home-manager.users.${user} = {
      programs.wezterm = {
        enable = true;
        extraConfig =
          ''
            local config = wezterm.config_builder()

            local ssh_domains = {}

            for host, ssh_config in pairs(wezterm.enumerate_ssh_hosts("${config.sops.templates.hcax-config.path}")) do
              table.insert(ssh_domains, {
                name = host,
                remote_address = ssh_config.hostname .. ":" .. ssh_config.port,
                assume_shell = 'Posix',
              })
            end
          ''
          + "config = "
          + luaFormat {
            underline_thickness = 3;
            underline_position = -3;
            font_size = 12.0;
            font = mkLuaInline ''wezterm.font ("FiraCode Nerd Font")'';
            ssh_domains = mkLuaInline "ssh_domains";
            use_fancy_tab_bar = false;
            hide_tab_bar_if_only_one_tab = true;
            tab_bar_at_bottom = true;
            default_cursor_style = "SteadyBar";

            window_frame = {
              font_size = 10.0;
            };
            keys = mkLuaInline ''{ { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay } }'';
            color_scheme = "Bamboo";
          }
          + ''
            local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
            -- you can put the rest of your Wezterm config here
            smart_splits.apply_to_config(config, {
              -- the default config is here, if you'd like to use the default keys,
              -- you can omit this configuration table parameter and just use
              -- smart_splits.apply_to_config(config)

              -- directional keys to use in order of: left, down, up, right
              direction_keys = { 'h', 'j', 'k', 'l' },
              -- modifier keys to combine with direction_keys
              modifiers = {
                move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
                resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
              },
            })
            return config
          '';
      };
    };
  };
}
