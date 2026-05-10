{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  replaceVars,
}:

let
  version = "2.7.0-bronze";

  src = fetchFromGitHub {
    owner = "CnTeng";
    repo = "silverbullet";
    rev = version;
    hash = "sha256-NZA2hiBvJESg+oPmUeb5uXF0OdoBYTpaUxo/Wdy0ywU=";
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "silverbullet-frontend";
    inherit version src;

    npmDepsHash = "sha256-cn7s7JK6JV9NF0w+gTU56Y3bnR0xKMzvNRlh5GIpuA8=";

    patches = [
      (replaceVars ./override-public-version.patch { inherit version; })
    ];

    postBuild = ''
      npm run build:plug-compile
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r client_bundle public_version.ts $out/

      runHook postInstall
    '';
  });
in
buildGoModule {
  pname = "silverbullet";
  inherit version src;

  vendorHash = "sha256-SvMPyJbSVrj+lwXrNh2WEYNI41oqlzchFxCtXvIl4/4=";
  subPackages = [ "." ];

  preBuild = ''
    cp -r ${frontend}/client_bundle .
    cp ${frontend}/public_version.ts .
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 "$GOPATH/bin/silverbullet" $out/bin/silverbullet

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${version}/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    mainProgram = "silverbullet";
    platforms = lib.platforms.unix;
  };
}
