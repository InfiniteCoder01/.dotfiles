{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05-small";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-index-database, ... }@attrs: {
    nixosConfigurations."InfiniteCoders-System" = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        (import ./packages.nix (attrs // { inherit system pkgs pkgs-stable; }))
      ];
    };
  };
}
