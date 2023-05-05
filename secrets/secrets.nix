let
  yufei = "age1yubikey1q27kxdp7zrdlu40vjcma83xxv7ustj735hnnvs4sqwu8wgwjs96t2m89wfq";

  rxdell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjCERLilIWtMakao9loYQXAb+6I3kPHuOVVdsTANs8U rxdell";
  rxaws = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfR8ocU9mPnUG2YYhqAm8WAfkYnGkxQ3lusE/TzpvE9 rxaws";
  rxhz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvDCURMwDZ6Kpldv4HCZbS8bBzPD03rt6dCHX7UmK2C rxhz";
in {
  "services/cache.age".publicKeys = [yufei rxhz];
  "services/caddy.age".publicKeys = [yufei rxaws rxhz];
  "services/miniflux.age".publicKeys = [yufei rxhz];
  "services/naive.age".publicKeys = [yufei rxaws rxhz];
  "services/vaultwarden.age".publicKeys = [yufei rxhz];

  "shell/naive.age".publicKeys = [yufei rxdell];
}
