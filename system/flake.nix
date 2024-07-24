{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    nix-snapd.url = "https://flakehub.com/f/io12/nix-snapd/*.tar.gz";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."InfiniteCoders-System" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in [
        ./configuration.nix
        (import ./packages.nix (inputs // { inherit system pkgs; }))
      ];
    };
  };
}
