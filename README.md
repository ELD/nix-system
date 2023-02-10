# Nix System Configuration

[![system build](https://api.cirrus-ci.com/github/ELD/nix-system.svg?branch=master)](https://cirrus-ci.com/github/ELD/nix-system)

_Note: This repository is a manual fork of [kclejeune/system](https://github.com/kclejeune/system) that I've heavily modified.
Because it's a manual fork, rebasing is often done by overlaying commits from upstream onto this repo. Many thanks and attribution
to kclejeune for the original work and helping me get going with Nix, Flakes, and managing a system configuration declaratively._

This repository manages system configurations for all of my
macOS, nixOS, and linux machines.

## Structure

This repository is a [flake](https://nixos.wiki/wiki/Flakes). All system configurations are defined
in [flake.nix](./flake.nix). Platorm specific configurations are found defined in the flake outputs
`darwinConfigurations`, `nixosConfigurations` for macOS and NixOS respectively.

### Overlapping Nix-Darwin and NixOS

Nix-Darwin and NixOS configurations share as much overlap as possible in the common module, [./modules/common.nix](./modules/common.nix).
Platform specific modules add onto the common module in [./modules/darwin/default.nix](./modules/darwin/default.nix) and [./modules/nixos/default.nix](./modules/nixos/default.nix) for macOS and NixOS respectively.

### Decoupled Home Manager Configuration

My home-manager configuration is entirely decoupled from NixOS and nix-darwin configurations.
This means that all of its modules are found in [./modules/home-manager](./modules/home-manager).
These modules are imported into all other configurations in the common module similarly to this:

```nix
{ config, pkgs, ... }: {
  home-manager.users.edattore = import ./home-manager/home.nix;
}
```

This means that [home.nix](./modules/home-manager/home.nix) is fully compatible as a standalone configuration, managed with the `home-manager` CLI.
This allows close replication of any user config for any linux system running nix. These configurations are defined in the `homeConfigurations` output.

### User Customization

User "profiles" are specified in [./profiles](./profiles); these modules configure
contextual, identity-specific settings such as SSL certificates or work vs. personal email addresses.
When possible, home-manager functionality is extracted into [./profiles/home-manager](./profiles/home-manager), as mentioned previously

## Installing a Configuration

### Non-NixOS Prerequisite: Install Nix Package Manager

Run the installer script to perform a multi-user installation on darwin or linux:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

Note that this step is naturally skipped on NixOS since `nix` is the package manager by default.

## System Bootstrapping

### NixOS

Follow the installation instructions, then run

```bash
sudo nixos-install --flake github:ELD/nix-system#indium
```

### Darwin/Linux

Clone this repository into `~/.nixpkgs` with

```bash
git clone https://github.com/ELD/nix-system ~/.nixpkgs
```

You can bootstrap a new nix-darwin system using

```bash
nix --extra-experimental-features "nix-command flakes" run github:ELD/nix-system#sysdo -- bootstrap --darwin
```

or a home-manager configuration using

```bash
nix --extra-experimental-features "nix-command flakes" develop -c sysdo bootstrap --home-manager
```

## `sysdo` CLI

The `sysdo` utility is a python script that wraps `nix`, `darwin-rebuild`, `nixos-rebuild`,
and `home-manager` commands to provide a consistent interface across multiple platforms. It has some dependencies which are defined in the `devShell`
flake output. Documentation for this tool is found in [sysdo.md](./docs/sysdo.md).
