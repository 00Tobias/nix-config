{
  description = "My all-encompassing Nix config based on flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    rep.url = "github:eraserhd/rep";
    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, ... } @ inputs:
    let
      eglstreams-overlay = final: prev: {
        wlroots = prev.wlroots.overrideAttrs (oldAttrs: {
          pname = "wlroots-eglstreams";
          version = "unstable-2022-02-10";
          src = prev.fetchFromGitHub {
            owner = "danvd";
            repo = "wlroots-eglstreams";
            rev = "f3282ab9b545db8e76452332be63e2fbe380f1e9"; # pin
            sha256 = "0m4x63wnh7jnr0i1nhs221c0d8diyf043hhx0spfja6bc549bdxr";
          };
        });
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (oldAttrs: {
          version = "unstable-2022-02-21";
          src = prev.fetchFromGitHub {
            owner = "swaywm";
            repo = "sway";
            rev = "f8990523b456ad4eba2bd9c22dff87772d7b0953"; # pin
            sha256 = "17wlvrh2nn87k54gj2xw89b12fc8inrfvv0x2hbysb6y1wldfrf7";
          };
          buildInputs = oldAttrs.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
        });
      };
    in
    {
      nixosConfigurations = {
        den = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/common.nix
            ./hosts/den.nix
            ./modules/xorg.nix
            # ./modules/wayland.nix
            ./modules/kdeconnect.nix
            ./modules/mullvad.nix
            ./modules/nextdns.nix
            ./modules/pipewire.nix
            ./modules/syncthing.nix
            ./modules/steam.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [{ home.keyboard.layout = "se"; }];
              home-manager.users.toxic = { pkgs, ... }: {
                imports = [
                  # Main programs
                  ./home/kakoune/kakoune.nix
                  ./home/firefox
                  ./home/nyxt/nyxt.nix
                  ./home/emacs/emacs.nix
                  ./home/qutebrowser.nix

                  # River
                  # ./home/river

                  # Wayland
                  # ./home/wayland/sway.nix
                  # ./home/wayland/waybar.nix
                  # ./home/wayland/foot.nix

                  # Xorg
                  ./home/xorg/bspwm.nix
                  ./home/xorg/dunst.nix
                  ./home/xorg/rofi.nix
                  ./home/xorg/alacritty.nix

                  # Extra programs
                  ./home/wezterm
                  ./home/chromium.nix
                  ./home/vscodium.nix
                  ./home/plover.nix
                  ./home/spotify.nix
                  ./home/discord.nix

                  # Misc
                  ./home/programs.nix
                  ./home/term.nix
                  ./home/langs.nix
                  ./home/games.nix
                  ./home/gtk.nix
                ];
              };
            }
            {
              nixpkgs.overlays = [
                eglstreams-overlay
                inputs.emacs-overlay.overlay
                inputs.nix-alien.overlay
              ];
            }
          ];
        };
        haven = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/common.nix
            ./hosts/haven.nix
            ./modules/wayland.nix
            ./modules/mullvad.nix
            ./modules/nextdns.nix
            ./modules/pipewire.nix
            ./modules/syncthing.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [{ home.keyboard.layout = "se"; }];
              home-manager.users.toxic = { pkgs, ... }: {
                imports = [
                  ./home/emacs/emacs.nix
                  ./home/qutebrowser.nix
                  ./home/wayland/sway.nix
                  ./home/wayland/waybar.nix
                  ./home/wayland/foot.nix
                  ./home/xorg/dunst.nix
                  ./home/langs.nix
                  ./home/scripts.nix
                  ./home/term.nix
                  ./home/gtk.nix
                ];
              };
            }
            {
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlay
              ];
            }
          ];
        };
      };
    };
}
