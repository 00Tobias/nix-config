{ config, pkgs, ... }: {
  services.picom = {
    enable = true;
    experimentalBackends = true;
    shadow = true;
    # shadowExclude = [ "" ];
  };
}
