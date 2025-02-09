{
  description = "My config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terminal-config = {
      url = "github:iancleary/terminal-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , terminal-config
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
    in
    rec {
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

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
        lint = nixpkgs.legacyPackages.${system}.callPackage ./shells/lint.nix { };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

      homeConfigurations =
        let
          defaultHomeManagerModules = [
            ./modules/home-manager
            terminal-config.homeManagerModules.default
          ];
          specialArgs = { inherit inputs outputs; };
        in
        {
          # Ubuntu WSL at home
          windows-tower = home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages.x86_64-linux;
            extraSpecialArgs = specialArgs;
            modules = defaultHomeManagerModules ++ [
              ./wsl/default.nix
            ];
          };
          # Ubuntu WSL at home
          framework = home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages.x86_64-linux;
            extraSpecialArgs = specialArgs;
            modules = defaultHomeManagerModules ++ [
              ./wsl/default.nix
            ];
          };
        };
    };
}
