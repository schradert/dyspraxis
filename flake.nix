{
  description = "Practice problems for courses, books, and sandboxing";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgs-stable.url = github:nixos/nixpkgs/nixos-23.11;
    systems.url = github:nix-systems/default;

    flake-parts.url = github:hercules-ci/flake-parts;
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    dream2nix.url = github:nix-community/dream2nix;
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = github:mitchellh/zig-overlay;
    zig.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    with inputs;
      flake-parts.lib.mkFlake {inherit inputs;} {
        imports = [./nix];
        systems = import systems;
        perSystem = {pkgs, ...}: {
          packages = dream2nix.lib.importPackages {
            projectRoot = ./.;
            projectRootFile = "flake.nix";
            packagesDir = ./projects;
            packageSets.nixpkgs = pkgs;
            packageSets.inputs = inputs;
          };
        };
      };
}
