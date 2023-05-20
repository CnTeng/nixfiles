lib:
with lib; rec {
  _match3hex = builtins.match "([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";
  _parseDigit = hex: let
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
    getAttr hex dict;

  toDec = hex: let
    characters = stringToCharacters hex;
    values = map _parseDigit characters;
  in
    toString (foldl (acc: n: acc * 16 + n) 0 values);

  hexToRgb = hex:
    concatStringsSep ", " (map toDec (_match3hex hex));
}
