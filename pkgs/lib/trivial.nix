{ lib, ... }:
rec {
  removeHashTag = hex: lib.removePrefix "#" hex;

  toDec =
    hex:
    let
      parseDigit =
        char:
        if char < "a" then
          lib.toInt char
        else
          {
            "a" = 10;
            "b" = 11;
            "c" = 12;
            "d" = 13;
            "e" = 14;
            "f" = 15;
          }
          .${char};

      chars = lib.stringToCharacters hex;
      values = map parseDigit chars;
    in
    toString (lib.foldl (x: y: x * 16 + y) 0 values);

  toRgb =
    hex:
    let
      matchHex = builtins.match "([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";
    in
    lib.concatStringsSep ", " (map toDec (matchHex (removeHashTag hex)));
}
