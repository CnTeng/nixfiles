{ pkgs ? null }:

{
  caddy-with-plugins = pkgs.callPackage ./caddy-with-plugins { };
  naiveproxy = pkgs.callPackage ./naiveproxy { };

}
