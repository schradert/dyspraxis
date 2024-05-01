{nix, ...}: {
  perSystem = {
    canivete.dream2nix.packages.nnfs-rust.module = {dream2nix, ...}: {
      imports = with dream2nix.modules.dream2nix; [rust-cargo-lock rust-crane];
      inherit ((nix.importTOML ./Cargo.toml).package) name version;
      mkDerivation.src = ./.;
      paths.package = ./.;
    };
    pre-commit.settings = {
      settings.rust.cargoManifestPath = toString ./Cargo.toml;
      hooks.rustfmt.enable = true;
    };
  };
}
