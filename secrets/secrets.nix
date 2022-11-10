let
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL07kChgxyYZ+jF5IdxttkqOOZ4M9IBfxc+ANZL7PUaW agenix";

in
{
  "publickeys.age".publicKeys = [ agenix ];

  "rxtx_hostname.age".publicKeys = [ agenix ];
  "rxtx_ed25519.age".publicKeys = [ agenix ];

  "github_auth_ed25519.age".publicKeys = [ agenix ];
  "vaultwarden.env.age".publicKeys = [ agenix ];
  "Caddyfile.age".publicKeys = [ agenix ];
}
