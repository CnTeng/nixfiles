pkgs: oldAttrs:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  hyprctlPatch = pkgs.writeTextFile {
    name = "waybar-hyprctl.diff";
    text = ''
      diff --git a/src/modules/wlr/workspace_manager.cpp b/src/modules/wlr/workspace_manager.cpp
      index c1b68c8..489ea87 100644
      --- a/src/modules/wlr/workspace_manager.cpp
      +++ b/src/modules/wlr/workspace_manager.cpp
      @@ -467,7 +467,8 @@ auto Workspace::handle_clicked(GdkEventButton *bt) -> bool {
         if (action.empty())
           return true;
         else if (action == "activate") {
      -    zext_workspace_handle_v1_activate(workspace_handle_);
      +    const std::string command = "${hyprctl} dispatch workspace " + name_;
      +	   system(command.c_str());
         } else if (action == "close") {
           zext_workspace_handle_v1_remove(workspace_handle_);
         } else {
    '';
  };
in {
  # Add wlr/workspace click support for hyprland
  mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  patches = (oldAttrs.patches or [ ]) ++ [ hyprctlPatch ];
}
