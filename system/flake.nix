{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05-small";
    nixpkgs-ondsel.url = "github:pinpox/nixpkgs/init-ondsel-src";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-ondsel, nix-index-database, ... }@attrs: {
    nixosConfigurations."InfiniteCoders-System" = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            packageOverrides = pkgs: {
                warp-beta = import (fetchTarball {
                  url = "https://github.com/imadnyc/nixpkgs/archive/refs/heads/warp-terminal-initial-linux.zip";
                  sha256 = "sha256:1blbvznzgcymlbfmr3xw7qnvnq7ncvc60wrzmznvacwjrmbnsw9l";
                }) {
                    inherit system;
                    config.allowUnfree = true;
                    overlays = [ (self: super: {
                      warp-terminal = super.warp-terminal.overrideAttrs (super: {
                        # postFixup = ''
                        #   wrapProgram $out/bin/warp-terminal --set LD_LIBRARY_PATH ${(pkgs.lib.makeLibraryPath super.runtimeDependencies)}
                        # '';
                      });
                    })];
                };
            };
          };
          overlays = [
            (final: prev: {
              ondsel = (import nixpkgs-ondsel { inherit system; }).ondsel;
            })
          ];
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
