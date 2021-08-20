{ config, pkgs, ... }: {

  networking = {
    resolvconf.useLocalResolver = true; # Use NextDNS resolver.
    kdeconnect.enable = true;
  };
  services = {
    mullvad-vpn.enable = true;
    nextdns = {
      enable = true;
      arguments = [ "-config" "1dc65b" "-report-client-info" ];
    };
  };
}
