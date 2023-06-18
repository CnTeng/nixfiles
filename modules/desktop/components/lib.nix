lib:
with lib; rec {
  _matchHex =
    builtins.match "([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";

  _parseDigit = char:
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

  toDec = hex:
    let
      chars = stringToCharacters hex;
      values = map _parseDigit chars;
    in toString (foldl (x: y: x * 16 + y) 0 values);

  hexToRgb = hex: concatStringsSep ", " (map toDec (_matchHex hex));
}
