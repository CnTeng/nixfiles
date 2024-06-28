{
  config,
  lib,
  data,
  user,
  ...
}:
let
  cfg = config.programs.ssh;
  hosts = lib.filterAttrs (n: v: v.type == "remote") data.hosts;

  mkSecret = name: key: {
    ${name} = {
      mode = "0444";
      inherit key;
    };
  };

  mkTemplate = name: content: {
    ${name} = {
      inherit content;
      mode = "0444";
    };
  };

  mkKownHosts = host: keys: lib.concatMapStringsSep "\n" (key: "${host} ${key}") keys;

  hostsSecrets = lib.concatMapAttrs (
    host: hostData:
    lib.mergeAttrsList (
      [
        (mkSecret "ssh/${host}/ipv4" "hosts/${host}/ip/ipv4")
        (mkSecret "ssh/${host}/host_rsa_key.pub" "hosts/${host}/host_rsa_key/public_key")
        (mkSecret "ssh/${host}/host_ed25519_key.pub" "hosts/${host}/host_ed25519_key/public_key")
      ]
      ++ (lib.optionals hostData.initrd_ssh [
        (mkSecret "ssh/${host}/initrd_rsa_key.pub" "hosts/${host}/initrd_rsa_key/public_key")
        (mkSecret "ssh/${host}/initrd_ed25519_key.pub" "hosts/${host}/initrd_ed25519_key/public_key")
      ])
    )
  ) hosts;

  hostsConfig = lib.concatMapAttrs (
    host: _:
    (mkTemplate "ssh/${host}/config" ''
      Host ${host}
        HostName ${config.sops.placeholder."ssh/${host}/ipv4"}
        User ${user}
        IdentityFile /home/${user}/.ssh/id_ed25519_sk_rk_ybk5@nixos
        IdentityFile /home/${user}/.ssh/id_ed25519_sk_rk_ybk5c@nixos
    '')
  ) hosts;

  kownHostsList = lib.mapAttrsToList (
    host: hostData:
    mkKownHosts config.sops.placeholder."ssh/${host}/ipv4" (
      [
        config.sops.placeholder."ssh/${host}/host_rsa_key.pub"
        config.sops.placeholder."ssh/${host}/host_ed25519_key.pub"
      ]
      ++ lib.optionals hostData.initrd_ssh [
        config.sops.placeholder."ssh/${host}/initrd_rsa_key.pub"
        config.sops.placeholder."ssh/${host}/initrd_ed25519_key.pub"
      ]
    )
  ) hosts;

  knownHosts = mkTemplate "ssh/known_hosts" (lib.concatStringsSep "\n" kownHostsList);

in
{
  programs.ssh.extraConfig = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      host: hostData: "Include ${config.sops.templates."ssh/${host}/config".path}"
    ) hosts
  );

  environment.etc."ssh/ssh_config".text = lib.mkForce ''
    ${cfg.extraConfig}

    Host *
    AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
    GlobalKnownHostsFile ${config.sops.templates."ssh/known_hosts".path}
  '';

  sops.templates = hostsConfig // knownHosts;
  sops.secrets = hostsSecrets;

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".ssh" ];
  };
}
