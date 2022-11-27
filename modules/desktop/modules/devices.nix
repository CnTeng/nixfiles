{ ... }:

{
  # Power
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };

  # Light
  programs.light.enable = true;
}
