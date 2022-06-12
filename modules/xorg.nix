{ config, lib, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      layout = "se";

      displayManager = {
        lightdm.enable = true;
        # Login should be done at decryption time or not at all
        autoLogin = {
          enable = true;
          user = "toxic";
        };
      };
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];

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
