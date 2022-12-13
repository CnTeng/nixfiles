let
  yufei = "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";
  users = [ yufei ];

  rxdell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjCERLilIWtMakao9loYQXAb+6I3kPHuOVVdsTANs8U rxdell";
  rxtx = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPH1/9YLdEA+/NQzNzSkVlN6RWxpsgpH+Z0N53n5PZut rxtx";
  hosts = [ rxdell rxtx ];
in
{
  "laptop/naiveConfig.age".publicKeys = [ yufei rxdell ];

  "server/caddyFile.age".publicKeys = [ yufei rxtx ];
  "server/vaultwardenEnv.age".publicKeys = [ yufei rxtx ];
}
