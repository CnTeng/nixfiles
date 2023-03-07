let
  yufei =
    "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";

  rxdell =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjCERLilIWtMakao9loYQXAb+6I3kPHuOVVdsTANs8U rxdell";
  rxaws =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfR8ocU9mPnUG2YYhqAm8WAfkYnGkxQ3lusE/TzpvE9 rxaws";
  rxhz =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvDCURMwDZ6Kpldv4HCZbS8bBzPD03rt6dCHX7UmK2C rxhz";
  rxtx =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPH1/9YLdEA+/NQzNzSkVlN6RWxpsgpH+Z0N53n5PZut rxtx";
in {
  "proxy/naiveConfig.age".publicKeys = [ yufei rxdell ];

  "services/naiveFile.age".publicKeys = [ yufei rxaws rxhz rxtx ];
  "services/caddyFile.age".publicKeys = [ yufei rxaws rxhz rxtx ];
  "services/vaultwardenEnv.age".publicKeys = [ yufei rxaws rxhz rxtx ];
  "services/minifluxAdmin.age".publicKeys = [ yufei rxaws rxhz rxtx ];
}
