{ lib, ... }:
rec {
  getFileNames = { path, exclude }: lib.subtractLists exclude (lib.attrNames (builtins.readDir path));

  importModule =
    path:
    map (n: path + "/${n}") (getFileNames {
      inherit path;
      exclude = [
        "default.nix"
        "secrets.yaml"
      ];
    });

  mkKnownHosts =
    hosts:
    let
      mkPublicKey = host: type: ip: publicKey: {
        "${host}-${type}" = {
          hostNames = [ ip ];
          inherit publicKey;
        };
      };

      mkKnownHost =
        host: hostData:
        lib.mergeAttrsList [
          (mkPublicKey host "rsa" hostData.ipv4 hostData.host_rsa_key_pub)
          (mkPublicKey host "ed25519" hostData.ipv4 hostData.host_ed25519_key_pub)
        ];
    in
    lib.concatMapAttrs mkKnownHost hosts;

  mkMatchBlocks =
    user: hosts:
    let
      mkMatchBlock = user: host: hostData: {
        ${host} = {
          hostname = hostData.ipv4;
          inherit user;
          identityFile = [
            "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
            "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
          ];
        };
      };
    in
    lib.concatMapAttrs (mkMatchBlock user) hosts;

  removeHashTag = hex: lib.removePrefix "#" hex;
}
