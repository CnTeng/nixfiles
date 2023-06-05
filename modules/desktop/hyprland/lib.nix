config: lib:
with lib; rec {
  _mkShortcut = mods: map (key: "${mods}, ${key}");
  _mkCommand = dispatcher: map (param: "${dispatcher}, ${param}");

  mkKeymap = mods: keys: dispatcher: params:
    concatStringsSep "\n" (
      zipListsWith (shortcut: command: "bind = ${shortcut}, ${command}")
      (_mkShortcut mods keys)
      (_mkCommand dispatcher params)
    );

  mkSubmap = name: shortcut: submap: ''
    bind = ${shortcut}, submap, ${name}
    submap = ${name}

    ${submap}

    bind = , escape, submap, reset
    submap = reset
  '';

  getExe' = comp: cmd: "${lib.getBin config.desktop'.components.${comp}.package}/bin/${cmd}";

  _mkRules = f: objects: concatStringsSep "\n" (map f objects);
  _mkWindowsRules = rule: _mkRules (window: "windowrulev2 = ${rule}, ${window}");

  mkOpacity = v: _mkWindowsRules "opacity ${v}";
  mkFloat = _mkWindowsRules "float";
  mkBlurls = _mkRules (namespace: "blurls = ${namespace}");

  mkSectionStr = section: options: ''
    ${section} {
      ${concatStringsSep "\n  " (
      mapAttrsToList (
        name: value:
          if isAttrs value
          then "${name} ${toString value}"
          else let
            valueStr =
              if isBool value
              then boolToString value
              else toString value;
          in "${name} = ${valueStr}"
      )
      options
    )}
    }'';
}
