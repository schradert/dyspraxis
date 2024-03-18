{inputs, ...}: {
  imports = [./pre-commit.nix];
  perSystem = {
    lib,
    pkgs,
    self',
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.zig.overlays.default];
    };
    devShells.default = pkgs.mkShell {
      inputsFrom = with lib;
        lists.flatten [
          (builtins.attrValues (removeAttrs self'.devShells ["default"]))
          (with attrsets; mapAttrsToList (_: pkg: pkg.devShell or []) self'.packages)
        ];
      # TODO why isn't this already provided the pdm module??? and why can't I define a new one that actually adds this dependency to the development shell
      packages = [pkgs.pdm];
    };
  };
}
