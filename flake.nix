{
  description = "NixOS from scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager

          # Dodatna konfiguracija direktno u flake-u
          {
            nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];

        specialArgs = { inherit home-manager; };
      };
    };
}
