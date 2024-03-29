{ config, pkgs, ... }: {
  sound.enable = false;

  hardware = {
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      config.pipewire = {
        context.properties.default.clock.rate = 44100;
      };
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
