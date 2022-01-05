{ config, lib, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      layout = "se";

      displayManager.startx.enable = true;

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          scrollMethod = "twofinger";
          naturalScrolling = true;
        };
      };
    };
  };
}
