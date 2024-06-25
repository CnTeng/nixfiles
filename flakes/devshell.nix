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
          ssh-to-age
          syncthing
          (opentofu.withPlugins (p: [
            p.aws
            p.cloudflare
            p.external
            p.hcloud
            p.local
            p.null
            p.shell
            p.sops
            p.tls
          ]))
        ];

        shellHook = config.pre-commit.installationScript;
      };
    };
}
