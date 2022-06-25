{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    betterdiscordctl
    discocss
  ];
  xdg.desktopEntries = {
    discordQB = {
      name = "Discord (QB)";
      icon = "discord";
      exec = "qutebrowser --target window -- https://discord.com/app";
      # exec = "qutebrowser --target window --qt-arg name discord -B ${config.xdg.dataHome}/discordqb -C ${config.xdg.configHome}/qutebrowser/config.py -- https://discord.com/app";
    };
  };
  xdg.configFile = {
    # Workaround that actually lets me use Discord while waiting for nixpkgs to update lmao
    # Although discord uses settings.json to dynamically change some stuff, so that's borked now
    # "discord/settings.json".text = ''"SKIP_HOST_UPDATE": true'';

    # Custom theme using discocss because betterdiscord blows
    "discocss/custom.css".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Dyzean/Tokyo-Night/d660358b8664e36b13f7b183461f64aac93d2e33/tokyo-night.theme.css";
      sha256 = "0w5lzy0zcf5bagnpi5ax974a61glkhnr40gx8dzi1cs1f1bvyn0q";
    };
  };
}
