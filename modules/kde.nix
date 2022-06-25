{ config, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      layout = "se";
      displayManager.sddm = {
        enable = true;
      };
      desktopManager.plasma5.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    plasma-pass
    libsForQt5.ark
    libsForQt5.dragon
    libsForQt5.gwenview
    libsForQt5.lightly
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.powerdevil
  ];
}
