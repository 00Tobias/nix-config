{ config, pkgs, ... }: {
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "toxic" ];
      keepEnv = true;
      persist = true;
    }];
  };
  security.sudo.enable = true; # Changing this to false has some side effects, I should figure that out some day
}
