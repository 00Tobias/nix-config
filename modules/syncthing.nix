{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "toxic";
    dataDir = "/home/toxic/";
    configDir = "/home/toxic/.config/syncthing";
  };
}
