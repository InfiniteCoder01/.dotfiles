{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-index-database.url = "github:nix-community/nix-index-database";
    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
  };

  outputs = { nixpkgs, nixpkgs-unstable, determinate, nix-index-database, ... }@attrs:
    let
      hostname = "InfiniteCoder";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = attrs // { inherit hostname; };
        modules = [
          determinate.nixosModules.default
          nix-index-database.nixosModules.nix-index
          ./configuration.nix
          ./desktop.nix
          ./home.nix
        ];
      };
    };
}
