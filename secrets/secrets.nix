let
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL07kChgxyYZ+jF5IdxttkqOOZ4M9IBfxc+ANZL7PUaW agenix";

in
{
  "ssh/publicKeys.age".publicKeys = [ agenix ];
  "ssh/githubAuthKey.age".publicKeys = [ agenix ];
  "ssh/rxtxHostname.age".publicKeys = [ agenix ];
  "ssh/rxtxKey.age".publicKeys = [ agenix ];

  "server/naiveConfig.age".publicKeys = [ agenix ];
  "server/caddyFile.age".publicKeys = [ agenix ];
  "server/vaultwardenEnv.age".publicKeys = [ agenix ];
}
