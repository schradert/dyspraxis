{lib, ...}: {
  flake.dream2nixModules.nnfs-rust = {dream2nix, ...}: {
    imports = with dream2nix.modules.dream2nix; [rust-cargo-lock rust-crane];
    inherit ((lib.importTOML ./Cargo.toml).package) name version;
    mkDerivation.src = ./.;
  };
  perSystem.pre-commit.settings = {
    settings.rust.cargoManifestPath = toString ./Cargo.toml;
    hooks.rustfmt.enable = true;
  };
}
