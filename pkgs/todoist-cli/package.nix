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
    rev = "271b1f3a8b6103c8c31ce43c0b72338a69c16442";
    sha256 = "sha256-SYI8F2nbtPxX5lclEyGLJpcysARWftwK5UJe+EsZ4LQ=";
  };

  vendorHash = "sha256-WDr354E7rYQNGw0cjoPN0HDfVofp8hUVzN7ybnbuGf4=";

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
