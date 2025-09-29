{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule {
  pname = "todoist-cli";
  version = "0.1.0-unstable-2025-09-29";

  src = fetchFromGitHub {
    owner = "CnTeng";
    repo = "todoist-cli";
    rev = "34e11b8f4e353cbeff7d4ea8c0c5c09c76ae48d0";
    sha256 = "sha256-nsHVGF57UjsqdqvDdH92trpHlwPxlOMYoVezeVpjQRg=";
  };

  vendorHash = "sha256-BCBedZ9ne5ucL9j6/mc/rzmOE2InC+InWXs9y+610xk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/todoist-cli $out/bin/todoist

    installShellCompletion --cmd todoist \
      --bash <($out/bin/todoist completion bash) \
      --zsh <($out/bin/todoist completion zsh) \
      --fish <($out/bin/todoist completion fish)
  '';

  meta = {
    description = "A CLI client for Todoist";
    homepage = "https://github.com/CnTeng/todoist-cli";
    license = lib.licenses.mit;
    mainProgram = "todoist";
    maintainers = with lib.maintainers; [ CnTeng ];
    platforms = lib.platforms.all;
  };
}
