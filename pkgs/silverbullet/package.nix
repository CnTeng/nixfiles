{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "silverbullet";
  version = "2.8.0-unstable-2026-05-19";

  src = fetchFromGitHub {
    owner = "silverbulletmd";
    repo = "silverbullet";
    rev = "0be1ad91938aa26cc77db50451d8831524718127";
    hash = "sha256-M9lHbIZifZbE29UfC5EX84STWjrbX7xWP+6Lpt4nRIg=";
  };

  vendorHash = "sha256-8zZlhVptJq8y3k2DBghJ0lPNcIcaZYkrxN67b6dNBPs=";

  subPackages = [ "." ];

  frontend = buildNpmPackage {
    pname = "silverbullet-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-g5IAIIXUGzOIRrnAcUH1MWYBD8cZqpZPx3hpUA4O/iE=";

    patches = [
      ./hide-comment-block.patch
      (replaceVars ./override-public-version.patch {
        inherit (finalAttrs) version;
      })
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
