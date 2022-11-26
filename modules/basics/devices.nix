{ user, ... }:

{
  # Video group is necessary for light
  users.users.${user}.extraGroups = [ "camera" "video" "audio" ];
}
