{ config, pkgs, ... }: {
  services = {
    mullvad-vpn.enable = true;
  };

  # The service for some reason doesn't come with the client
  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ];
}
