{ pkgs, user, ... }:

let
  # Require for image previewer
  file = "${pkgs.file}/bin/file";
  pistol = "${pkgs.pistol}/bin/pistol";

  lfKittyPreview = pkgs.writeShellScript "lf_kitty_preview" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${file} -Lb --mime-type "$file")" =~ ^image ]]; then
        kitty +icat --silent --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file"
        exit 1
    fi

    ${pistol} "$file"
  '';

  lfKittyClean = pkgs.writeShellScript "lf_kitty_clean" ''
    kitty +icat --clear --silent --transfer-mode file
  '';
in
{
  home-manager.users.${user} = {
    programs.lf = {
      enable = true;
      extraConfig = ''
        set previewer ${lfKittyPreview}
        set cleaner ${lfKittyClean}
      '';
    };
  };
}
