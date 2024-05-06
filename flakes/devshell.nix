{
  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          jq
          colmena
          nvfetcher
          sops
          (opentofu.withPlugins (p: [
            p.aws
            p.cloudflare
            p.external
            p.hcloud
            p.null
            p.sops
            p.tls
            p.local
          ]))
        ];

        shellHook = config.pre-commit.installationScript;
      };
    };
}
