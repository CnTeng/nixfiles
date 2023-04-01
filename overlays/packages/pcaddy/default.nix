# Copy https://github.com/NixOS/nixpkgs/pull/191883#issuecomment-1250652290
# & https://github.com/NixOS/nixpkgs/issues/14671
{ lib, stdenv, go, srcOnly, buildGoModule, sources, ... }:
let
  caddySrc = srcOnly sources.caddy.src;

  forwardProxySrc = srcOnly sources.forwardproxy.src;

  cloudflareSrc = srcOnly sources.cloudflare.src;

  combinedSrc = stdenv.mkDerivation {
    name = "caddy-src";

    nativeBuildInputs = [ go ];

    buildCommand = ''
      export GOCACHE="$TMPDIR/go-cache"
      export GOPATH="$TMPDIR/go"

      mkdir -p "$out/pcaddy"

      cp -r ${caddySrc} "$out/caddy"
      cp -r ${forwardProxySrc} "$out/forwardproxy"
      cp -r ${cloudflareSrc} "$out/cloudflare"

      cd "$out/pcaddy"

      go mod init caddy
      echo "package main" >> main.go
      echo 'import caddycmd "github.com/caddyserver/caddy/v2/cmd"' >> main.go
      echo 'import _ "github.com/caddyserver/caddy/v2/modules/standard"' >> main.go
      echo 'import _ "github.com/caddyserver/forwardproxy"' >> main.go
      echo 'import _ "github.com/caddy-dns/cloudflare"' >> main.go
      echo "func main(){ caddycmd.Main() }" >> main.go
      go mod edit -require=github.com/caddyserver/caddy/v2@${sources.caddy.version}
      go mod edit -replace github.com/caddyserver/caddy/v2=../caddy
      go mod edit -require=github.com/caddyserver/forwardproxy@v0.0.0
      go mod edit -replace github.com/caddyserver/forwardproxy=../forwardproxy
      go mod edit -require=github.com/caddy-dns/cloudflare@v0.0.0
      go mod edit -replace github.com/caddy-dns/cloudflare=../cloudflare
    '';
  };
in buildGoModule {
  pname = "pcaddy";
  inherit (sources.caddy) version;

  src = combinedSrc;

  vendorHash = "sha256-zxT8G06uCa5czBuZzeiiktontoim1zpZZzOtO70sJgw=";

  overrideModAttrs = _: {
    postPatch = "cd pcaddy";

    postConfigure = ''
      go mod tidy
    '';

    postInstall = ''
      mkdir -p "$out/.magic"
      cp go.mod go.sum "$out/.magic"
    '';
  };

  postPatch = "cd pcaddy";

  postConfigure = ''
    cp vendor/.magic/go.* .
  '';

  meta = with lib; {
    homepage = "https://github.com/caddyserver/caddy";
    description =
      "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ CnTeng ];
  };
}
