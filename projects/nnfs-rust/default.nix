{
  dream2nix,
  lib,
  ...
}: {
  imports = with dream2nix.modules.dream2nix; [rust-cargo-lock rust-crane];
  inherit ((lib.importTOML ./Cargo.toml).package) name version;
  mkDerivation.src = ./rust;
  mkDerivation.passthru.pre-commit.pre-commit.settings = {
    settings.rust.cargoManifestPath = ./Cargo.toml;
    hooks.rustfmt.enable = true;
    hooks.clippy.enable = true;
  };
}
