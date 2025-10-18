{
  prev,
  lib,
  fetchFromGitHub,
  coreutils,
}:
prev.onedrive.overrideAttrs (_: {
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v2.5.7";
    hash = "sha256-IllPh4YJvoAAyXDmSNwWDHN/EUtUuUqS7TOnBpr3Yts=";
  };

  postInstall = ''
    installShellCompletion --cmd onedrive \
      --bash contrib/completions/complete.bash \
      --fish contrib/completions/complete.fish \
      --zsh contrib/completions/complete.zsh

    for s in $out/lib/systemd/user/onedrive.service $out/lib/systemd/system/onedrive@.service; do
      substituteInPlace $s \
        --replace-fail "/bin/sh -c 'sleep 15'" "${lib.getExe' coreutils "sleep"} 15"
    done
  '';
})
