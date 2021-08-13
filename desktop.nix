let
  pkgs = import <nixpkgs> { };
  thisDir = builtins.toString ./.;
in
{
  name = "my-config";

  # Run Doom Emacs inside a sandboxed nix-shell session.
  xdg.menu.applications.discord-canary = {
    Name = "Discord Canary (Wayland)";
    Icon = "discord-canary";
    Exec = "electron --enable-features=UseOzonePlatform --ozone-platform=wayland /nix/store/0vx4mdibhyg6p4hxwb3c03pjxb00fn0p-discord-canary-0.0.126/opt/DiscordCanary/resources/app.asar";
    StartupWMClass = "discord";
    Terminal = false;
    Type = "Application";
  };
}
