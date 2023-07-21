{lib}:
with lib; let
  _mkShortcut = mods: map (key: "${mods}, ${key}");
  _mkCommand = dispatcher: map (param: "${dispatcher}, ${param}");

  _mkRules = f: objects: concatStringsSep "\n" (map f objects);

  _mkWindowsRules = rule:
    _mkRules (window: "windowrulev2 = ${rule}, ${window}");
in {
  mkKeymap = mods: keys: dispatcher: params:
    concatStringsSep "\n"
    (zipListsWith (shortcut: command: "bind = ${shortcut}, ${command}")
      (_mkShortcut mods keys) (_mkCommand dispatcher params));

  mkSubmap = name: shortcut: submap: ''
    bind = ${shortcut}, submap, ${name}
    submap = ${name}

    ${submap}

    bind = , escape, submap, reset
    submap = reset
  '';

  mkOpacity = v: _mkWindowsRules "opacity ${v}";
  mkFloat = _mkWindowsRules "float";
  mkBlurls = _mkRules (namespace: "blurls = ${namespace}");

  mkSectionStr = section: options: let
    sectionStr = ''
      ${section} {
        ${
        concatStringsSep "\n  " (mapAttrsToList (name: value:
          if isAttrs value
          then "${name} ${toString value}"
          else let
            valueStr =
              if isBool value
              then boolToString value
              else toString value;
          in "${name} = ${valueStr}")
        options)
      }
      }
    '';
  in
    builtins.replaceStrings [
      "col_inactive_border"
      "col_active_border"
      "col_group_border"
      "col_group_border_active"
      "col_shadow"
      "col_shadow_inactive"
    ] [
      "col.inactive_border"
      "col.active_border"
      "col.group_border"
      "col.group_border_active"
      "col.shadow"
      "col.shadow_inactive"
    ]
    sectionStr;
}
