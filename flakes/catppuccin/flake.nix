{
  inputs = {
    batTheme = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    btopTheme = {
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
      batTheme
      btopTheme
      fcitx5Cat
      fishCat
      foliateCat
      paletteCat
      qt5ctCat
      starshipCat
      ;
  };
}
