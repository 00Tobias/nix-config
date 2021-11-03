{
  description = "Toxic's all-encompassing Nix config based on flakes";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # FIXME: Pin until nixpkgs-wayland figures out that
    # https://github.com/NixOS/nixpkgs/pull/143138 is a thing
    # (already included in the git version)
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland?rev=b1c82141688b0e4b7174d2379ff8aa63c41a5864";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    cachix.url = "github:cachix/cachix";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, home-manager, nixpkgs, ... } @ inputs: {
    homeConfigurations = {
      nixosHomeConfig = inputs.home-manager.lib.homeManagerConfiguration {
        homeDirectory = "/home/toxic/";
        username = "toxic";

        # Let Home Manager install and manage itself
        programs.home-manager.enable = true;

        home.stateVersion = "21.11";
      };
    };
    nixosHomeConfig = self.homeConfigurations.nixosHomeConfig.activationPackage;

    system.stateVersion = "21.11";

    nixosConfigurations = {
      den = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/common.nix
          ./hosts/den.nix
          ./modules/doas.nix
          ./modules/kdeconnect.nix
          ./modules/mullvad.nix
          ./modules/nextdns.nix
          ./modules/pipewire.nix
          ./modules/syncthing.nix
          ./modules/yubikey.nix
          ./modules/unfree.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toxic = { pkgs, ... }: {
              imports = [
                ./emacs/emacs.nix
                ./neovim/neovim.nix
                ./nyxt/nyxt.nix
                ./home/programs.nix
                ./home/langs.nix
                ./home/scripts.nix
                ./home/pass.nix
                ./home/qutebrowser.nix
                ./home/discord.nix
                ./home/spotify.nix
                ./home/term.nix
                ./home/gtk.nix
                ./home/games.nix
                ./home/kakoune/kakoune.nix
                ./home/firefox/firefox.nix
                ./home/wayland/sway.nix
                ./home/wayland/waybar.nix
                ./home/wayland/foot.nix
                ./home/xorg/i3.nix
                ./home/xorg/polybar.nix
                ./home/xorg/rofi.nix
                ./home/xorg/dunst.nix
                ./home/xorg/picom.nix
                ./home/xorg/kitty.nix
              ];
            };
          }
          {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.nixpkgs-wayland.overlay-egl
              inputs.emacs-overlay.overlay
              inputs.neovim-nightly-overlay.overlay
            ];
          }
        ];
      };
      haven = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/common.nix
          ./hosts/haven.nix
          ./modules/doas.nix
          ./modules/kdeconnect.nix
          ./modules/mullvad.nix
          ./modules/nextdns.nix
          ./modules/pipewire.nix
          ./modules/syncthing.nix
          ./modules/yubikey.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toxic = { pkgs, ... }: {
              imports = [
                ./emacs/emacs.nix
                ./home/programs.nix
                ./home/langs.nix
                ./home/scripts.nix
                ./home/pass.nix
                ./home/term.nix
                ./home/gtk.nix
                ./home/kakoune/kakoune.nix
                ./home/firefox/firefox.nix
                ./home/wayland/sway.nix
                ./home/wayland/waybar.nix
                ./home/wayland/foot.nix
                ./home/xorg/dunst.nix
              ];
            };
          }
          {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.nixpkgs-wayland.overlay
              inputs.emacs-overlay.overlay
              inputs.neovim-nightly-overlay.overlay
            ];
          }
        ];
      };
    };
  };
}
