{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "silverbullet";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = finalAttrs.version;
    hash = "sha256-8TRarV40wcs0kAbh+xe/IihbubQY0S8EPUKoAio6wK0=";
  };

  vendorHash = "sha256-8zZlhVptJq8y3k2DBghJ0lPNcIcaZYkrxN67b6dNBPs=";

  subPackages = [ "." ];

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-g5IAIIXUGzOIRrnAcUH1MWYBD8cZqpZPx3hpUA4O/iE=";

    patches = [
      (replaceVars ./override-public-version.patch { inherit (finalAttrs) version; })
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
  };

  preBuild = ''
    cp -r ${finalAttrs.frontend}/client_bundle .
    cp ${finalAttrs.frontend}/public_version.ts .
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 "$GOPATH/bin/silverbullet" $out/bin/silverbullet

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aorith
      CnTeng
    ];
    mainProgram = "silverbullet";
  };
})
