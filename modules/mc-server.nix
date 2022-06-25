{ config, pkgs, ... }: {
  # For lazymc's proxy
  networking.firewall.allowedUDPPorts = [ 25566 ];
  networking.firewall.allowedTCPPorts = [ 25566 ];
  services.minecraft-server = {
    enable = true;
    openFirewall = true;
    package = pkgs.papermc;
    eula = true;
    jvmOpts = "-Xmx3G -Xms3G";
    # declarative = true;
    serverProperties = {
      enable-jmx-monitoring = false;
      enable-command-block = true;
      gamemode = "survival";
      level-name = "deez";
      motd = "google play minecraft pocket edition";
      pvp = true;
      difficulty = "normal";
      network-compression-threshold = 256;
      max-tick-time = 60000;
      require-resource-pack = false;
      max-players = 69;
      use-native-transport = true;
      online-mode = true;
      enable-status = true;
      allow-flight = true;
      broadcast-rcon-to-ops = true;
      view-distance = 12;
      allow-nether = true;
      server-port = 25565;
      sync-chunk-writes = true;
      op-permission-level = 4;
      prevent-proxy-connections = false;
      entity-broadcast-range-percentage = 100;
      player-idle-timeout = 0;
      debug = false;
      force-gamemode = false;
      rate-limit = 0;
      white-list = false;
      broadcast-console-to-ops = true;
      spawn-npcs = true;
      spawn-animals = true;
      snooper-enabled = true;
      function-permission-level = 2;
      spawn-monsters = true;
      enforce-whitelist = false;
      spawn-protection = 0;
      max-world-size = 29999984;
    };
  };
}
