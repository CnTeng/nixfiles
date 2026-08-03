{
  hm'.programs.herdr = {
    enable = true;
    settings = {
      theme = {
        auto_switch = true;
        dark_name = "vesper";
        light_name = "one-light";
      };
      ui = {
        sidebar_start_collapsed = true;
        toast.delivery = "terminal";
        sound.enabled = false;
      };
    };
  };

  preservation'.user.directories = [ ".config/herdr" ];
}
