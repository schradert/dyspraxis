{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = with lib;
        lists.flatten [
          (builtins.attrValues (removeAttrs self'.devShells ["default"]))
          (with attrsets; mapAttrsToList (_: pkg: pkg.devShell or []) self'.packages)
        ];
    };
  };
}
