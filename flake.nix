{
  description = "Practice problems for courses, books, and sandboxing";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;
    systems.url = github:nix-systems/default;

    flake-parts.url = github:hercules-ci/flake-parts;
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";

    dream2nix.url = github:nix-community/dream2nix;
    dream2nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    with inputs;
      flake-parts.lib.mkFlake {inherit inputs;} {
        imports = [./nnfs ./pre-commit.nix];
        systems = import systems;
      };
}
