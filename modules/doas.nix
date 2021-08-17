{ config, pkgs, ... }: {
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "toxic" ];
      keepEnv = true;
      persist = true;
    }];
  };
  security.sudo.enable = false;
}
