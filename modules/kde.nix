{ config, pkgs, ... }: {
  services = {
    xserver = {
      displayManager.sddm = {
        enable = true;
      };
      desktopManager.plasma5.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    plasma-pass
    libsForQt5.ark
    libsForQt5.lightly
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.powerdevil
  ];
}
