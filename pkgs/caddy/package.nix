{ prev, lib }:
let
  plugins = [ "github.com/caddy-dns/cloudflare" ];
  pluginNames = map (plugin: builtins.elemAt (lib.splitString "@" plugin) 0) plugins;
in
prev.caddy.overrideAttrs (old: {
  vendorHash = "sha256-7hLCPVYlk9zY7GUelWymDKjdInMjhQn1JhLQ3af+57A=";

  prePatch = ''
    # Add modules to main.go
    for plugin in ${toString pluginNames}; do
      sed -i "/plug in Caddy modules here/a _ \"$plugin\"" cmd/caddy/main.go
    done

    # Outside go-modules derivation, copy go.mod and go.sum
    [ -z "$goModules" ] || cp "$goModules/go.mod" "$goModules/go.sum" .
  '';

  preBuild = ''
    # In go-modules derivation, fetch the plugins
    [ -n "$goModules" ] || {
      for plugin in ${toString plugins}; do
        go get $plugin
      done
      go mod tidy
    }
  '';

  modPostBuild = ''
    # Once the modules are vendorized, also save go.mod and go.sum
    cp go.mod go.sum vendor
  '';

})
