# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  caddy = {
    pname = "caddy";
    version = "v2.6.4";
    src = fetchFromGitHub ({
      owner = "caddyserver";
      repo = "caddy";
      rev = "v2.6.4";
      fetchSubmodules = false;
      sha256 = "sha256-3a3+nFHmGONvL/TyQRqgJtrSDIn0zdGy9YwhZP17mU0=";
    });
  };
  catppuccin-fcitx5 = {
    pname = "catppuccin-fcitx5";
    version = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "fcitx5";
      rev = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";
      fetchSubmodules = false;
      sha256 = "sha256-uFaCbyrEjv4oiKUzLVFzw+UY54/h7wh2cntqeyYwGps=";
    });
    date = "2022-10-05";
  };
  catppuccin-plymouth = {
    pname = "catppuccin-plymouth";
    version = "d4105cf336599653783c34c4a2d6ca8c93f9281c";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "plymouth";
      rev = "d4105cf336599653783c34c4a2d6ca8c93f9281c";
      fetchSubmodules = false;
      sha256 = "sha256-quBSH8hx3gD7y1JNWAKQdTk3CmO4t1kVo4cOGbeWlNE=";
    });
    date = "2022-12-10";
  };
  cloudflare = {
    pname = "cloudflare";
    version = "a9d3ae2690a1d232bc9f8fc8b15bd4e0a6960eec";
    src = fetchFromGitHub ({
      owner = "caddy-dns";
      repo = "cloudflare";
      rev = "a9d3ae2690a1d232bc9f8fc8b15bd4e0a6960eec";
      fetchSubmodules = false;
      sha256 = "sha256-bqnk4XkhUI7YhCv24ha8mds5EaYphnYj8wy/mFOieqI=";
    });
    date = "2023-02-24";
  };
  fcitx5-pinyin-zhwiki = {
    pname = "fcitx5-pinyin-zhwiki";
    version = "20230329";
    src = fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20230329.dict";
      sha256 = "sha256-w0GvAJMnC71AlUs2T3HJkXz6Kj1+fg+VBghV8LmjI0g=";
    };
  };
  forwardproxy = {
    pname = "forwardproxy";
    version = "ef4a5997791af459e80d166ea4a58f83db4309c2";
    src = fetchFromGitHub ({
      owner = "klzgrad";
      repo = "forwardproxy";
      rev = "ef4a5997791af459e80d166ea4a58f83db4309c2";
      fetchSubmodules = false;
      sha256 = "sha256-uiwCDjU35N+scgQg5ULgNnmML/XE6NgkhzmGfo1Ef9c=";
    });
    date = "2023-02-19";
  };
  naiveproxy = {
    pname = "naiveproxy";
    version = "v112.0.5615.49-1";
    src = fetchurl {
      url = "https://github.com/klzgrad/naiveproxy/releases/download/v112.0.5615.49-1/naiveproxy-v112.0.5615.49-1-linux-x64.tar.xz";
      sha256 = "sha256-qRSH5hNvxx3Uc5ZpfRFPLGUUhSLz/F83NaRk9Y090Mg=";
    };
  };
  ttf-ms-win10 = {
    pname = "ttf-ms-win10";
    version = "417eb232e8d037964971ae2690560a7b12e5f0d4";
    src = fetchFromGitHub ({
      owner = "streetsamurai00mi";
      repo = "ttf-ms-win10";
      rev = "417eb232e8d037964971ae2690560a7b12e5f0d4";
      fetchSubmodules = false;
      sha256 = "sha256-UwkHlrSRaXhfoMlimyXFETV9yq1SbvUXykrhigf+wP8=";
    });
    date = "2021-02-10";
  };
  ttf-wps-fonts = {
    pname = "ttf-wps-fonts";
    version = "b3e935355afcfb5240bac5a99707ffecc35772a2";
    src = fetchFromGitHub ({
      owner = "BannedPatriot";
      repo = "ttf-wps-fonts";
      rev = "b3e935355afcfb5240bac5a99707ffecc35772a2";
      fetchSubmodules = false;
      sha256 = "sha256-oRVREnE3qsk4gl1W0yFC11bHr+cmuOJe9Ah+0Csplq8=";
    });
    date = "2017-08-15";
  };
  wemeet = {
    pname = "wemeet";
    version = "3.14.0.402";
    src = fetchurl {
      url = "https://updatecdn.meeting.qq.com/cos/5a910969828531efb24add85626e2372/TencentMeeting_0300000000_3.14.0.402_x86_64_default.publish.deb";
      sha256 = "sha256-lpCXijWI3FQJXB6ofF+eKAweIyanvKxdwQrrLP37HDA=";
    };
  };
}
