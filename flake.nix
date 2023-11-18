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
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, nixpkgs, homeManager, nix-vscode-extensions, nix-index-database, nixneovimplugins }: {
    homeConfigurations = {
      "riky" = homeManager.lib.homeManagerConfiguration {
        modules = [
          ./home.nix
          nix-index-database.hmModules.nix-index
          {
            programs.nix-index-database.comma.enable = true;
            home.sessionVariables.NIX_PATH = nixpkgs.outPath;
          }
          ({pkgs, ...}: { nixpkgs.overlays = [nixneovimplugins.overlays.default]; })
        ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit nix-vscode-extensions; };
      };
    };

  };
}
