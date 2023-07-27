{lib, ...}:
with lib; {
  options.basics'.colors.flavour = mkOption {
    type = types.enum ["Latte" "Frappe" "Macchiato" "Mocha"];
    default = "Mocha";
  };
}
