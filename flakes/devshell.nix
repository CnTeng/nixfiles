{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          jq
          sops
          age
          (opentofu.withPlugins (p: [
            p.aws
            p.cloudflare
            p.external
            p.github
            p.hcloud
            p.local
            p.null
            p.shell
            p.sops
            p.tls
          ]))
          config.treefmt.build.wrapper
        ];

        shellHook = config.pre-commit.installationScript;
      };
    };
}
