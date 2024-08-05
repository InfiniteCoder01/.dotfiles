{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05-small";
    # emacs-overlay.url = "github:nix-community/emacs-overlay/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-index-database, ... }@inputs: {
    nixosConfigurations."InfiniteCoders-System" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # overlays = [ (import self.inputs.emacs-overlay) ];
        };
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      in [
        (import ./configuration.nix { inherit inputs pkgs; })
        nix-index-database.nixosModules.nix-index
        (import ./packages.nix (inputs // { inherit system pkgs pkgs-stable; }))
      ];
    };
  };
}
