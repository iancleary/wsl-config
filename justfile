# list recipes
help:
  just --list

now := `date +"%Y-%m-%d_%H.%M.%S"`
hostname := lowercase(`uname -n`)

# echo hostname (uname -n)
echo:
  @echo "{{ hostname }}"

# Update the flake lock file
update:
  nix flake update

# Update the configuration using home-manager (non-nixos or WSL)
home-manager:
  home-manager switch --flake .#{{ hostname }}

# garbage collect
gc:
  nix-store --gc

# Lint all files (similar to GitHub Actions), setup nix-shell
lint:
  nix develop --accept-flake-config .#lint

# format all the files, when in a nix-shell
format:
  nixpkgs-fmt .

# check all files (similar to GitHub Actions), when in a nix-shell
check:
  actionlint
  yamllint .
  selene .
  stylua --check .
  statix check
  nixpkgs-fmt --check .

# Check flake evaluation
flake:
  nix flake check --no-build --all-systems
