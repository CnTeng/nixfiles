{ prev }:
prev.lrzsz.overrideAttrs {
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=incompatible-pointer-types";
}
