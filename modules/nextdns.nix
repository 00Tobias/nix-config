{ config, pkgs, ... }: {
  networking = {
    resolvconf.useLocalResolver = true; # Use NextDNS resolver.
  };
  services = {
    nextdns = {
      enable = true;
      arguments = [ "-config" "1dc65b" "-report-client-info" ];
    };
  };
}
