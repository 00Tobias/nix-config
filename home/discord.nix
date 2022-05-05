{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    discord-canary
  ];
  xdg.configFile."discordcanary/settings.json".text = ''"SKIP_HOST_UPDATE": true'';
}
