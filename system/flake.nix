{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    determinate.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, determinate, nix-index-database, ... }@attrs:
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
