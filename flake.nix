{
  description = "Toxic's all-encompassing Nix config based on flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
                ./home/programs.nix
                ./home/langs.nix
                ./home/scripts.nix
                ./home/pass.nix
                ./home/nyxt.nix
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
              inputs.emacs-overlay.overlay
              inputs.neovim-nightly-overlay.overlay
            ];
          }
        ];
      };
    };
  };
}
