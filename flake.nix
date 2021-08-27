{
  description = "Toxic's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = { self, home-manager, nixpkgs, ... }@inputs: {
    homeConfigurations = {
      nixosHomeConfig = inputs.home-manager.lib.homeManagerConfiguration {
        homeDirectory = "/home/toxic/";
        username = "toxic";
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/den.nix
          ./modules/networking.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toxic = { pkgs, ... }: {
              imports = [
                # inputs.nix-doom-emacs.hmModule
                ./home.nix
              ];
              # # TODO: Waiting for literate config to get support
              # programs.doom-emacs = {
              #   enable = true;
              #   doomPrivateDir = ./doom.d;
              # };
            };
          }
          {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.nixpkgs-wayland.overlay
              inputs.emacs-overlay.overlay
            ];
          }
        ];
      };
    };
    nixosHomeConfig = self.homeConfigurations.nixosHomeConfig.activationPackage;
  };
}
