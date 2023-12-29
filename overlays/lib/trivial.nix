{ lib, ... }:
with lib; rec {
  removeHashTag = hex: removePrefix "#" hex;

  toRgb = rgb: "${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}";

  toDec = hex:
    let
      parseDigit = char:
        if char < "a" then
          toInt char
        else
          {
            "a" = 10;
            "b" = 11;
            "c" = 12;
            "d" = 13;
            "e" = 14;
            "f" = 15;
          }.${char};

      chars = stringToCharacters hex;
      values = map parseDigit chars;
    in toString (foldl (x: y: x * 16 + y) 0 values);

  toRgb' = hex:
    let
      matchHex =
        builtins.match "([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";
    in concatStringsSep ", " (map toDec (matchHex (removeHashTag hex)));
}
