{
  description = "Home manager configuration";

  inputs = {
    # nixpkgs.url = "flake:nixpkgs/nixos-24.11";
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
    pwndbg.url = "github:pwndbg/pwndbg";
  };

  outputs = { self, nixpkgs, homeManager, nix-index-database, nixgl, pwndbg }: {
    homeConfigurations = {
      "riky" = homeManager.lib.homeManagerConfiguration {
        extraSpecialArgs = { pwndbg = pwndbg; };
        modules = [
          ./home.nix
          nix-index-database.homeModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
            home.sessionVariables.NIX_PATH = nixpkgs.outPath;
            nix.registry.local = {
              from = { type = "indirect"; id = "nixpkgs"; };
              flake = nixpkgs;
            };
          }
          ({ pkgs, ... }: { nixpkgs.overlays = [ nixgl.overlay ]; })
        ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };

  };
}
