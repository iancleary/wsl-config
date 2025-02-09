{ inputs, outputs, config, lib, pkgs, ... }:
{
  home = rec {
    username = "iancleary";
    homeDirectory = lib.mkForce "/home/${username}"; # lib.mkForce allows for user to already exist
    stateVersion = lib.mkDefault "24.11";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.packages = [
    pkgs.hostname
    config.nix.package # This must be here, enable option below does not ensure that nix is available in path
  ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;
  nixpkgs.config.allowUnfree = true;
  nix = {
    enable = true;
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
      !include ./extra.conf
    '';
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    settings.nix-path = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
  programs.home-manager.enable = true;

  # Rest of the configuration is in a separate folder.
  imports = [
    inputs.terminal-config.homeManagerModules.default
  ];
}
