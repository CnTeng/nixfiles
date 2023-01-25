{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "${pkgs.btop}/share/btop/themes/tokyo-night.theme";
        theme_background = false;
        vim_keys = true;
        shown_boxes = "proc cpu mem net";
        update_ms = 2000;
        proc_sorting = "cpu direct";
        use_fstab = true;
        net_sync = true;
      };
    };
  };
}
