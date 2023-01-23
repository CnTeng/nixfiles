{ user, ... }:

{
  networking.firewall.allowedTCPPorts = [ 2222 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.memos = {
      image = "neosmemo/memos:0.10.2";
      ports = [ "2222:5230" ];
      volumes = [ "/home/${user}/.memos/:/var/opt/memos" ];
    };
  };
}
