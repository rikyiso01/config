{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, homeManager, nix-vscode-extensions, nix-index-database }: {
    homeConfigurations = {
      "riky" = homeManager.lib.homeManagerConfiguration {
        modules = [
          ./home.nix
          nix-index-database.hmModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
            home.sessionVariables.NIX_PATH = nixpkgs.outPath;
          }
        ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit nix-vscode-extensions; };
      };
    };

  };
}
