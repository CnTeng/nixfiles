{lib, ...}: {
  imports = lib.importModule {
    dir = ./.;
    exclude = ["secrets.yaml"];
  };
}
