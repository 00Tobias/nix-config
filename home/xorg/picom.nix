{ config, pkgs, ... }: {
  services.picom = {
    enable = true;
    experimentalBackends = true;
    backend = "xrender";
    shadow = true;
    # shadowExclude = [ "" ];
  };
}
