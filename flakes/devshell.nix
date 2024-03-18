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
            (terraform.withPlugins (p: [
              p.aws
              p.cloudflare
              p.external
              p.hcloud
              p.null
              p.sops
              p.tls
              p.local
            ]))
            jq
            colmena
            nvfetcher
            sops
            terraform-ls
            encrypt-tfstate
          ];
          shellHook = config.pre-commit.installationScript;
        };
    };
}
