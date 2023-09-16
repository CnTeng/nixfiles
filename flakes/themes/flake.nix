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

    fcitx5Theme = {
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

    palette = {
      url = "github:catppuccin/palette";
      flake = false;
    };
  };

  outputs = inputs @ {...}: {
    inherit
      (inputs)
      batTheme
      btopTheme
      fcitx5Theme
      fishCat
      foliateCat
      palette
      ;
  };
}
