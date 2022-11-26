{ ... }:

{
  # Power
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };

  # Sound
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Light
  programs.light.enable = true;
}
