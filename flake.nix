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
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    cachix.url = "github:cachix/cachix";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Temporary until I get my repo merged into the NUR
    toxic-nur.url = "/home/toxic/src/nur-pkgs/";
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
                ./home/programs.nix
                ./home/scripts.nix
                ./home/pass.nix
                ./home/qutebrowser.nix
                ./home/firefox.nix
                ./home/term.nix
                ./home/gtk.nix
                ./home/games.nix
                ./home/kakoune/kakoune.nix
                ./home/firefox/firefox.nix
                ./home/wayland/sway.nix
                ./home/wayland/foot.nix
                ./home/xorg/i3.nix
                ./home/xorg/polybar.nix
                ./home/xorg/rofi.nix
                ./home/xorg/dunst.nix
                ./home/xorg/picom.nix
              ];
            };
          }
          {
            nixpkgs.overlays = [
              # inputs.nur.overlay
              inputs.nixpkgs-wayland.overlay-egl
              inputs.emacs-overlay.overlay
              inputs.neovim-nightly-overlay.overlay

              # This is also temporary
              (final: prev: {
                nur = import inputs.nur {
                  nurpkgs = prev;
                  pkgs = prev;
                  repoOverrides = { toxic-nur = import inputs.toxic-nur { pkgs = prev; }; };
                };
              })
            ];
          }
        ];
      };
      haven = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/common.nix
          ./hosts/haven.nix
          ./modules/mc-server.nix
          ./modules/doas.nix
          ./modules/kdeconnect.nix
          ./modules/mullvad.nix
          ./modules/nextdns.nix
          ./modules/pipewire.nix
          ./modules/syncthing.nix
          ./modules/yubikey.nix
          ./modules/firejail.nix
          ./modules/unfree.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toxic = { pkgs, ... }: {
              imports = [
                ./home/scripts.nix
                ./home/emacs.nix
                ./home/pass.nix
                ./home/qutebrowser.nix
                ./home/term.nix
                ./home/gtk.nix
                ./home/games.nix
                ./home/xorg/i3.nix
                ./home/xorg/polybar.nix
                ./home/xorg/rofi.nix
                ./home/kakoune/kakoune.nix
                ./home/firefox/firefox.nix
                ./home/xorg/dunst.nix
                ./home/xorg/picom.nix
                ./home/xorg/programs.nix
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
