lib:
with lib; rec {
  _matchHex = builtins.match "([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";

  _parseDigit = let
    dict = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
    };
  in
    hex: getAttr hex dict;

  toDec = hex: let
    chars = stringToCharacters hex;
    values = map _parseDigit chars;
  in
    toString (foldl (x: y: x * 16 + y) 0 values);

  hexToRgb = hex: concatStringsSep ", " (map toDec (_matchHex hex));
}
