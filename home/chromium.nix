{ lib, config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium.override {
      commandLineArgs = lib.concatStringsSep " " [
        # GPU
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=VaapiVideoDecoder"
        # Reader mode
        "--enable-reader-mode"
        "--enable-dom-distiller"
        # Dark mode
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
        # Enable Wayland support
        "--ozone-platform-hint=auto"
        # Wayland Nvidia
        "--use-angle=vulkan"
        "--use-cmd-decoder=passthrough"
        # Disable unused stuff
        "--no-default-browser-check"
        "--no-service-autorun"
        "--disable-wake-on-wifi"
        "--disable-breakpad"
        "--disable-sync"
        "--disable-sync-preferences"
        "--disable-speech-api"
        "--disable-speech-synthesis-api"
      ];
    };
    extensions = [
      # AdNauseam
      {
        id = "ilkggpgmkemaniponkfgnkonpajankkm";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/dhowe/AdNauseam/releases/download/v3.13.1/adnauseam-3.13.1.chromium.crx";
          sha256 = "1h3i54cmp84ki3yagz9rm4zvj8q53f4mv3zn9kl5x4baan16bfz4";
        };
        version = "3.13.1";
      }
      # LibRedirect
      {
        id = "oladmjdebphlnjjcnomfhhbfdldiimaf";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/libredirect/libredirect/releases/download/v2.1.0/libredirect-2.1.0.crx";
          sha256 = "0zhhpxpzxlmhxmsii85j1h53q5dn8gsyc1g79hi43vrwnggiwhl1";
        };
        version = "2.1.0";
      }
    ];
  };
  xdg.desktopEntries = {
    # Using the 'chromium' wrapper script so commandLineArgs works
    discordChromium = {
      name = "Discord (Chromium)";
      icon = "discord";
      exec = "chromium --app=https://canary.discord.com/channels/@me --new-window";
    };
    soundcloudChromium = {
      name = "Soundcloud (Chromium)";
      icon = "soundcloud";
      exec = "chromium --app=https://soundcloud.com/discover --new-window";
    };
    spotifyChromium = {
      name = "Spotify (Chromium)";
      icon = "spotify";
      exec = "chromium --app=https://open.spotify.com/ --new-window";
    };
  };
}
