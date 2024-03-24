{ ... }:
{
  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      devShells.default =
        let
          opentofu = pkgs.opentofu.withPlugins (p: [
            p.aws
            p.cloudflare
            p.external
            p.hcloud
            p.null
            p.sops
            p.tls
            p.local
          ]);

          opentofu-alias = pkgs.writeShellApplication {
            name = "terraform";
            runtimeInputs = [ opentofu ];
            text = ''
              tofu "$@"
            '';
          };

          encrypt-tfstate = pkgs.writeShellApplication {
            name = "encrypt-tfstate";
            runtimeInputs = with pkgs; [ sops ];
            text = ''
              if sops --input-type json \
                   --output-type yaml \
                   --output tfstate.yaml \
                   --encrypt terraform.tfstate; then
                echo -e "\033[32msops: encryption successful\033[0m"
              else
                echo -e "\033[31msops: encryption failed\033[0m"
              fi
            '';
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            jq
            colmena
            nvfetcher
            sops
            encrypt-tfstate
            opentofu
            opentofu-alias
          ];
          shellHook = config.pre-commit.installationScript;
        };
    };
}
