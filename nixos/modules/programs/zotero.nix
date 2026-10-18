{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.zotero;
in
{
  options.programs'.zotero.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];

    hm'.home.packages = [ pkgs.zotero ];

    preservation'.user.directories = [
      ".cache/zotero"
      ".local/share/zotero"
      ".zotero"
    ];
  };
}
