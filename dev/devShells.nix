{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }:
    with lib;
      mkMerge [
        {
          # Shared devShells for each package devShell
          # Pre-commit has to be repository-wide so not per-project
          devShells.common = pkgs.mkShell {
            inputsFrom = trivial.pipe self'.packages [
              attrNames
              (trivial.concat ["common" "default" "pre-commit"])
              (removeAttrs self'.devShells)
              attrValues
            ];
          };
          # All devShells in one
          devShells.default = pkgs.mkShell {
            inputsFrom = trivial.pipe self'.devShells [
              (flip removeAttrs ["default"])
              attrValues
            ];
          };
        }
        {
          # Every package with a devShell exposes it to flake composed with common
          devShells = trivial.pipe self'.packages [
            (attrsets.filterAttrs (_: hasAttr "devShell"))
            (mapAttrs (_:
              flip trivial.pipe [
                (getAttr "devShell")
                lists.toList
                (trivial.concat [self'.devShells.common])
                (attrsets.setAttrByPath ["inputsFrom"])
                pkgs.mkShell
              ]))
          ];
        }
      ];
}
