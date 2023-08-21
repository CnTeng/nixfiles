{
  # inputs = let
  #   mkThemeSrc = builtins.mapAttrs (n: v: {
  #     url = "github:catppuccin/" + v;
  #     flake = false;
  #   });
  # in
  #   mkThemeSrc {
  #     alacrittyCat = "alacritty";
  #     batCat = "bat";
  #     btopCat = "btop";
  #     fcitx5Cat = "fcitx5";
  #     fishCat = "fish";
  #     foliateCat = "foliateCat";
  #     footCat = "foot";
  #     paletteCat = "palette";
  #     qt5ctCat = "qt5ct";
  #     starshipCat = "starship";
  #   };

  inputs = {
    batCat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    btopCat = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    fcitx5Cat = {
      url = "github:catppuccin/fcitx5";
      flake = false;
    };

    fishCat = {
      url = "github:catppuccin/fish";
      flake = false;
    };

    foliateCat = {
      url = "github:catppuccin/foliate";
      flake = false;
    };

    paletteCat = {
      url = "github:catppuccin/palette";
      flake = false;
    };

    qt5ctCat = {
      url = "github:catppuccin/qt5ct";
      flake = false;
    };

    starshipCat = {
      url = "github:catppuccin/starship";
      flake = false;
    };
  };

  outputs = inputs @ {...}: {
    inherit
      (inputs)
      alacrittyCat
      batCat
      btopCat
      fcitx5Cat
      fishCat
      foliateCat
      paletteCat
      qt5ctCat
      starshipCat
      ;
  };
}
