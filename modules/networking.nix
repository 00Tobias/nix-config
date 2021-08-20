{ config, pkgs, ... }: {

  networking = {
    resolvconf.useLocalResolver = true; # Use NextDNS resolver.
    firewall = {
      # For KDEConnect
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    };
  };
  services = {
    mullvad-vpn.enable = true;
    nextdns = {
      enable = true;
      arguments = [ "-config" "1dc65b" "-report-client-info" ];
    };
  };
}
