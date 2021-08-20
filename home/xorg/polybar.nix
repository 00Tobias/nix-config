{ config, pkgs, ... }: {
  services.polybar = {
    enable = true;
    script = "polybar bar &"; # TODO: Change this and actually make a config lol
  };
}
