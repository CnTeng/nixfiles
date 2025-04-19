{ prev }:
prev.commitizen.overridePythonAttrs (old: {
  pythonRelaxDeps = old.pythonRelaxDeps ++ [ "termcolor" ];
})
