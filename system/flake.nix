{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-index-database, ... }@attrs:
    let
      hostname = "InfiniteCoder";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = attrs // { inherit hostname; };
        modules = [
          nix-index-database.nixosModules.nix-index
          ./configuration.nix
          ./desktop.nix
          ./home.nix
        ];
      };
    };
}
