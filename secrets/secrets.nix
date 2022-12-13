let
  yufei = "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";
  users = [ yufei ];

  rxdell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwO3kofZ73tOjY4dQ7AWO+ykzX/qJ+t2sYAe9C08BLh rxdell";
  rxtx = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF014xXMNozcSPRuXMlnw+S5eDdzHIDIAyDMhb0VW2q1 rxtx";
  hosts = [ rxdell rxtx ];
in
{
  "common/publicKeys.age".publicKeys = users ++ hosts;
  "common/githubAuthKey.age".publicKeys = users ++ hosts;

  "laptop/rxtxKey.age".publicKeys = [ yufei rxdell ];
  "laptop/naiveConfig.age".publicKeys = [ yufei rxdell ];

  "server/caddyFile.age".publicKeys = [ yufei rxtx ];
  "server/vaultwardenEnv.age".publicKeys = [ yufei rxtx ];
}
