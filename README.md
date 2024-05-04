# My NixOS configuration

[![Made with Neovim](https://img.shields.io/badge/Made%20with-Neovim-green&?style=flat&logo=neovim)](https://neovim.io)
[![NixOS](https://img.shields.io/badge/NixOS-23.11-blue?style=flat&logo=nixos&logoColor=white)](https://nixos.org)

### In WSL2

We **strongly recommend** [enabling systemd](https://ubuntu.com/blog/ubuntu-wsl-enable-systemd), then installing Nix as normal.

> This is now enabled by default on Ubuntu 24.04 LTS.

To check, use:

`cat /etc/wsl.conf`

```ini
[boot]
systemd=true
```

### Installation

First make sure, your user is in the sudo/wheel group.

```bash
# Install git, curl and xz (e.g. for ubuntu)
sudo apt install git xz-utils curl

# Clone this repository
git clone https://github.com/iancleary/nixos-config.git
cd nixos-config

# Install nix (determinate-systems installation)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Open tempoary shell with nix and home-manager (shell.nix)
# if no flake.lock exists, run `nix flake update`
nix-shell

# Remove nix (this is necessary, so home-manager can install nix)
nix-env -e nix

# Install the configuration (adjust to the configuration/hostname you want to use )
home-manager switch --flake .#windows-tower

# Exit temporary shell
exit

# Set zsh (installed by nix) as default shell
echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells
usermod -s ~/.nix-profile/bin/zsh $USER
```

### Update

```bash
# Go to the repo directory
home-manager switch --flake .
```

## Resources

- [Nix config template](https://github.com/Misterio77/nix-starter-configs)
- [hlissner dotfiles](https://github.com/hlissner/dotfiles)
- [adfaure nix configuration](https://github.com/adfaure/nix_configuration)
- [Home-manager docs](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [Building NixOS ISO](https://ash64.eu/2022/03/08/custom-nixos-isos/)
- [NixOS manual](https://nixos.org/manual/nix/stable)
- [NixOS Configuration - Folder Structure This Repo was based on](https://github.com/LongerHV/nixos-configuration/tree/3d9baf05bc1bc34e2b9137a475db123e84b7aec5)
