{ prev }:
prev.terraform-providers
// {
  sops = prev.terraform-providers.sops.overrideAttrs (old: rec {
    version = "1.2.1";

    src = prev.fetchFromGitHub {
      owner = "CnTeng";
      repo = "terraform-provider-sops";
      rev = "v${version}";
      sha256 = "sha256-P45whPU3bSJuSeRXFsdSjGVNepsrGGq0xfPfX6cQ9Us=";
    };

    vendorHash = "sha256-4gtM8U//RXpYc4klCgpZS/3ZRzAHfcbOPTnNqlX4H7M=";
  });
}
