{sources}: oldAttrs: {
  inherit (sources.waybar) pname version src;
  postPatch = ''
    # use hyprctl to switch workspaces
    sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
  '';
  mesonFlags =
    oldAttrs.mesonFlags
    ++ ["-Dexperimental=true" "-Dcava=disabled"];
}
