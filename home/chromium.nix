{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--force-dark-mode"
      "--ignore-gpu-blocklist"
    ];
  };
}
