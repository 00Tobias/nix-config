{
  description = "Toxic's all-encompassing Nix config based on flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
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

    nixosConfigurations = {
      nix.binaryCaches = [ "https://nix-community.cachix.org" ];
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
          ./modules/firejail.nix
          ./modules/unfree.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toxic = { pkgs, ... }: {
              imports = [
                ./neovim/neovim.nix
                ./home/scripts.nix
                ./home/emacs.nix
                ./home/kakoune.nix
                ./home/pass.nix
                ./home/qutebrowser.nix
                ./home/firefox.nix
                ./home/term.nix
                ./home/gtk.nix
                ./home/games.nix
                ./home/xorg/i3.nix
                ./home/xorg/polybar.nix
                ./home/xorg/rofi.nix
                ./home/xorg/dunst.nix
                ./home/xorg/picom.nix
                ./home/xorg/programs.nix
              ];
            };
          }
          {
            nixpkgs.overlays = [
              # inputs.nur.overlay
              inputs.nixpkgs-wayland.overlay
              inputs.emacs-overlay.overlay
              inputs.neovim-nightly-overlay.overlay

              # This is also temporary
              # inputs.toxic-nur.overlay
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
    };
  };
}
