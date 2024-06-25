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

  mkSecret =
    name: key:
    (lib.nameValuePair name {
      mode = "0444";
      inherit key;
    });

  mkTemplate =
    name: content:
    (lib.nameValuePair name {
      inherit content;
      mode = "0444";
    });

  mkHostsAttrs = f: hosts: lib.listToAttrs (lib.flatten (lib.mapAttrsToList f hosts));

  hostsSecrets = mkHostsAttrs (
    host: hostData:
    [
      (mkSecret "ssh/${host}/ipv4" "hosts/${host}/ip/ipv4")
      (mkSecret "ssh/${host}/host_rsa_key.pub" "hosts/${host}/host_rsa_key/public_key")
      (mkSecret "ssh/${host}/host_ed25519_key.pub" "hosts/${host}/host_ed25519_key/public_key")
    ]
    ++ (lib.optionals hostData.initrd_ssh [
      (mkSecret "ssh/${host}/initrd_host_rsa_key.pub" "hosts/${host}/initrd_host_rsa_key/public_key")
      (mkSecret "ssh/${host}/initrd_host_ed25519_key.pub" "hosts/${host}/initrd_host_ed25519_key/public_key")
    ])
  ) hosts;

  hostsConfig = mkHostsAttrs (host: hostData: [
    (mkTemplate "ssh/${host}/config" ''
      Host ${host}
        HostName ${config.sops.placeholder."ssh/${host}/ipv4"}
        User ${user}
        IdentityFile /home/${user}/.ssh/id_ed25519_sk_rk_ybk5@nixos
        IdentityFile /home/${user}/.ssh/id_ed25519_sk_rk_ybk5c@nixos
    '')
  ]) hosts;

  knownHosts = lib.listToAttrs [
    (mkTemplate "ssh/known_hosts" (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          (
            host: hostData:
            ''
              ${config.sops.placeholder."ssh/${host}/ipv4"} ${
                config.sops.placeholder."ssh/${host}/host_rsa_key.pub"
              }
              ${config.sops.placeholder."ssh/${host}/ipv4"} ${
                config.sops.placeholder."ssh/${host}/host_ed25519_key.pub"
              }
            ''
            + (lib.optionalString hostData.initrd_ssh ''
              ${config.sops.placeholder."ssh/${host}/ipv4"} ${
                config.sops.placeholder."ssh/${host}/initrd_host_rsa_key.pub"
              }
              ${config.sops.placeholder."ssh/${host}/ipv4"} ${
                config.sops.placeholder."ssh/${host}/initrd_host_ed25519_key.pub"
              }
            '')
          )
        ) hosts
      )
    ))
  ];

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
