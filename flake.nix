{
  description = "RosettaLinux augmentation tool";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: let
    pkgs = nixpkgs.legacyPackages.aarch64-linux;
    inherit (pkgs) lib;

    patchRosetta = pkgs.callPackage ./patch-rosetta.nix {
      rosetta-spice = self.packages.aarch64-linux.rosetta-spice;
    };
  in {
    packages.aarch64-linux = rec {
      rosetta-spice = pkgs.rustPlatform.buildRustPackage {
        name = "rosetta-spice";
        src = lib.cleanSourceWith {
          filter = name: type: !(lib.hasSuffix ".nix" name);
          src = self;
        };
        cargoLock.lockFile = ./Cargo.lock;
      };
      rosetta-orig = pkgs.callPackage ./rosetta.nix { };
      rosetta = patchRosetta rosetta-orig;
    };

    devShell.aarch64-linux = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        rustc cargo rustfmt clippy
        pkg-config
        elfutils
        gdb
        bbe
      ];
    };
  } // {
    nixosModules.rosetta-spice = import ./nixos {
      flake = self;
    };
  };
}
