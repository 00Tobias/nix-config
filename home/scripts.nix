{ config, pkgs, ... }: {
  # TODO: Maybe change this to source files from a ./scripts dir?
  # FIXME: pkgs.writeShellScript is a way more elegant solution to this problem
  # which would make this file redundant
  home = {
    sessionPath = [ "${config.home.homeDirectory}/scripts/" ];
    packages = with pkgs; [
      # setwal.sh
      curl
      jq
      feh
      swaybg
    ];
    file = {
      "scripts/kakd" = {
        executable = true;
        text = ''
          server_name=$(basename `pwd`)
          socket_file=$(kak -l | grep $server_name)

          if [[ $socket_file == "" ]]; then
              # Create new kakoune daemon for current dir
              setsid kak -d -s $server_name &
          fi

          # and run kakoune (with any arguments passed to the script)
          kak -c $server_name $@
        '';
      };
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

          # Program to set wallpaper based on which display protocol is used
          if [[ -v "WAYLAND_DISPLAY" ]]; then
            swaybg -i /tmp/wallpapers/* -m fill
          else
            feh /tmp/wallpapers --bg-fill
          fi
        '';
      };
    };
  };
}
