{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, nix-index-database, ... }@attrs:
    let
      hostname = "InfiniteCoder";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = attrs // { inherit hostname; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                   inherit (final) config;
                   inherit (final.stdenv.hostPlatform) system;
                };
              })
            ];
          }
          nix-index-database.nixosModules.nix-index
          ./configuration.nix
          ./desktop.nix
          ./home.nix
          ./imperfect.nix
        ];
      };
    };
}
