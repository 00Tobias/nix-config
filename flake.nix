{
  description = "Toxic's NixOS configuration";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {self, nixpkgs, nur }:
  {
    nixosConfigurations.myConfig = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        # this adds a nur attribute set that can be used for example like this:
        #  ({ pkgs, ... }: {
        #    environment.systemPackages = [ pkgs.nur.repos.mic92.hello-nur ];
        #  })
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
    };
  };
}
