{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, nixpkgs, homeManager, nix-index-database, nixneovimplugins }: {
    homeConfigurations = {
      "riky" = homeManager.lib.homeManagerConfiguration {
        modules = [
          ./home.nix
          nix-index-database.hmModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
            home.sessionVariables.NIX_PATH = nixpkgs.outPath;
            nix.registry.local={
                from = {type="indirect"; id="nixpkgs"; };
                flake = nixpkgs;
            };
          }
          ({pkgs, ...}: { nixpkgs.overlays = [nixneovimplugins.overlays.default]; })
        ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };

  };
}
