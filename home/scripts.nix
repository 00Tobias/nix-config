{ config, pkgs, ... }: {
  # TODO: Maybe change this to source files from a ./scripts dir?
  home = {
    sessionPath = [ "${config.home.homeDirectory}/scripts/" ];
    packages = with pkgs; [
      curl
      jq
    ];
    file = {
      "scripts/setwal.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          # Clean the dir
          rm -f /tmp/wallpapers/*
          
          curl -s -H "User-Agent: cli:bash:v0.0.0" \
            https://www.reddit.com/r/wallpaper/top/.json \
            | jq '.data.children[].data.url' \
            | sed '/.jpeg\|.jpg\|.png\|.webp/!d' \
            | head -1 \
            | xargs -P 0 -n 1 -I {} bash -c 'curl -s -O {} --output-dir /tmp/wallpapers/'

          # If I'm on wayland, don't do anything, sway manages it for me :^)
          if [[ -v "WAYLAND_DISPLAY" ]]; then
            true
          else
            feh /tmp/wallpapers --bg-fill
          fi
        '';
      };
    };
  };
}
