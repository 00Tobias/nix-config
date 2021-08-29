{
  description = "Toxic's all-encompassing Nix config based on flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
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
