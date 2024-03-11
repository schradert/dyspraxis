{
  inputs,
  lib,
  ...
}:
with inputs; let
  cargoToml = "nnfs/rust/Cargo.toml";
in {
  flake.dream2nixModules.nnfs-rust = {
    config,
    dream2nix,
    ...
  }: {
    imports = with dream2nix.modules.dream2nix; [rust-cargo-lock rust-crane];
    inherit ((lib.importTOML (self + "/${cargoToml}")).package) name version;
    mkDerivation.src = ./rust;
  };
  flake.dream2nixModules.nnfs-python = {
    config,
    dream2nix,
    ...
  }: {
    imports = [dream2nix.modules.dream2nix.WIP-python-pdm];
    deps = {nixpkgs, ...}: {
      python = nixpkgs.python312;
    };
    inherit ((lib.importTOML config.pdm.pyproject).project) name version;
    mkDerivation.src = ./python;
    pdm.pyproject = config.mkDerivation.src + "/pyproject.toml";
  };
  perSystem = {pkgs, ...}: {
    packages.nnfs-python = dream2nix.lib.evalModules {
      packageSets.nixpkgs = pkgs;
      modules = [self.dream2nixModules.nnfs-python];
    };
    pre-commit.settings = {
      settings.rust.cargoManifestPath = cargoToml;
      hooks = {
        rustfmt.enable = true;
        clippy.enable = true;
        ruff.enable = true;
      };
    };
    packages.nnfs-rust = dream2nix.lib.evalModules {
      packageSets.nixpkgs = pkgs;
      modules = [self.dream2nixModules.nnfs-rust];
    };
  };
}
