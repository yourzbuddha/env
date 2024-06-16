{
  description = "Buddha's reproducible configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";

    # Follows
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {

     darwinConfigurations.andriib = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
        ];
      };
      homeConfigurations.andriib =
        let system = "aarch64-darwin";
            pkgs = nixpkgs.legacyPackages.${system};
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./nix/home.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfreePredicate = (pkg: true);
            }
          ];
        };
    };
}
