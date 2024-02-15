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
          terraform = pkgs.writeShellApplication {
            name = "terraform";
            runtimeInputs = [
              pkgs.sops
              (pkgs.terraform.withPlugins (
                p: with p; [
                  aws
                  cloudflare
                  sops
                  hcloud
                ]
              ))
            ];
            text = ''
              is_fmt=false
              is_version=false

              for arg in "$@"; do
                if [ "$arg" = "fmt" ]; then
                  is_fmt=true
                fi

                if [ "$arg" = "version" ]; then
                  is_version=true
                fi
              done

              if [ "$is_fmt" = "true" ] || [ "$is_version" = "true" ]; then
                terraform "$@"
                exit 0
              fi

              if sops --output-type json \
                   --output terraform.tfstate \
                   --decrypt tfstate.yaml; then
                echo -e "\033[32msops: decryption successful\033[0m\n"
              else
                echo -e "\033[31msops: decryption failed\033[0m\n"
              fi

              if terraform "$@"; then
                if sops --input-type json \
                     --output-type yaml \
                     --output tfstate.yaml \
                     --encrypt terraform.tfstate; then
                  echo -e "\n\033[32msops: encryption successful\033[0m"
                else
                  echo -e "\n\033[31msops: encryption failed\033[0m"
                fi
              fi
            '';
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            terraform
            colmena
            nvfetcher
            sops
            terraform-ls
          ];
          shellHook = config.pre-commit.installationScript;
        };
    };
}
