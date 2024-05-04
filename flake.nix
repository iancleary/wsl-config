{
  description = "My config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terminal-config = {
      url = "github:iancleary/terminal-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self
    , flake-utils
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , terminal-config
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
      overlays = {
          unstable = final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          };
          neovimPlugins = terminal-config.overlays.default;
      };

      legacyPackages = forAllSystems (system:
          import inputs.nixpkgs {
              inherit system;
              overlays = builtins.attrValues overlays;
              config.allowUnfree = true;
          }
      );

      homeManagerModules = import ./modules/home-manager;

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
        lint = nixpkgs.legacyPackages.${system}.callPackage ./shells/lint.nix { };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);
    in
    {
      homeConfigurations = {
        # Ubuntu WSL at home
        windows-tower = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs self; };
          modules = (builtins.attrValues homeManagerModules) ++ [
            ./wsl/windows-tower
          ];
        };
      };
    };
}
