# Copy https://github.com/NixOS/nixpkgs/pull/191883#issuecomment-1250652290
# & https://github.com/NixOS/nixpkgs/issues/14671
{ fetchFromGitHub, buildGoModule, stdenv, go,srcOnly }:
let
  caddySrc = srcOnly (fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v2.6.2";
    hash = "sha256-Tbf6RB3106OEZGc/Wx7vk+I82Z8/Q3WqnID4f8uZ6z0=";
  });# Clone from https://github.com/caddyserver/caddy

  forwardProxySrc = srcOnly (fetchFromGitHub {
    owner = "klzgrad";
    repo = "forwardproxy";
    rev = "caddy2-naive-20221007";
    hash = "sha256-MLbvv2G7ydTSmTw+tn89n1jJ51rz1BEmp5U1cM54qRo=";
  });

  cloudflareSrc = srcOnly (fetchFromGitHub {
    owner = "caddy-dns";
    repo = "cloudflare";
    rev = "815abbf88b27182428c342b2916a37b7134d266b";
    hash = "sha256-tz12CLrXLCf8Tjb9yj9rnysS3seLg3GAVFpybu3rIo8=";
  });

  combinedSrc = stdenv.mkDerivation {
    name = "caddy-src";

    nativeBuildInputs = [ go ];

    buildCommand = ''
      export GOCACHE="$TMPDIR/go-cache"
      export GOPATH="$TMPDIR/go"

      mkdir -p "$out/caddywithplugins"

      cp -r ${caddySrc} "$out/caddy"
      cp -r ${forwardProxySrc} "$out/forwardproxy"
      cp -r ${cloudflareSrc} "$out/cloudflare"

      cd "$out/caddywithplugins"

      go mod init caddy
      echo "package main" >> main.go
      echo 'import caddycmd "github.com/caddyserver/caddy/v2/cmd"' >> main.go
      echo 'import _ "github.com/caddyserver/caddy/v2/modules/standard"' >> main.go
      echo 'import _ "github.com/caddyserver/forwardproxy"' >> main.go
      echo 'import _ "github.com/caddy-dns/cloudflare"' >> main.go
      echo "func main(){ caddycmd.Main() }" >> main.go
      go mod edit -require=github.com/caddyserver/caddy/v2@v2.6.2
      go mod edit -replace github.com/caddyserver/caddy/v2=../caddy
      go mod edit -require=github.com/caddyserver/forwardproxy@v0.0.0
      go mod edit -replace github.com/caddyserver/forwardproxy=../forwardproxy
      go mod edit -require=github.com/caddy-dns/cloudflare@v0.0.0
      go mod edit -replace github.com/caddy-dns/cloudflare=../cloudflare
    '';
  };
in
buildGoModule {
  name = "caddy-with-plugins";

  src = combinedSrc;

  vendorHash = "sha256-BHYP2uq4bU4pzpwKRTtW7ylLdupcsa5SdBnIRMZ8Wbs=";

  overrideModAttrs = _: {
    postPatch = "cd caddywithplugins";

    postConfigure = ''
      go mod tidy
    '';

    postInstall = ''
      mkdir -p "$out/.magic"
      cp go.mod go.sum "$out/.magic"
    '';
  };

  postPatch = "cd caddywithplugins";

  postConfigure = ''
    cp vendor/.magic/go.* .
  '';
}
