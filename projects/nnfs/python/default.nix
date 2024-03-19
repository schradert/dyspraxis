{
  flake.dream2nixModules.nnfspy = {
    config,
    dream2nix,
    lib,
    ...
  }: let
    inherit (builtins) getAttr attrValues;
    inherit (lib.trivial) concat pipe;
    inherit (lib.lists) flatten;
    groupDeps = group:
      pipe config.groups.${group}.packages [
        attrValues
        (map (pkg:
          pipe pkg [
            attrValues
            (map (getAttr "public"))
          ]))
        flatten
      ];
  in {
    imports = [dream2nix.modules.dream2nix.WIP-python-pdm];
    deps = {nixpkgs, ...}: {
      inherit (nixpkgs.python312.pkgs) python pytestCheckHook;
    };
    mkDerivation.src = ./.;
    mkDerivation.nativeCheckInputs = concat (groupDeps "test") [config.deps.pytestCheckHook];
    pdm.pyproject = ./pyproject.toml;
    pdm.lockfile = ./pdm.lock;
    # The existing devShell doesn't work so we must forcefully override
    # config.deps.pdm should be listed after python so its own python doesn't override our package set
    public.devShell = lib.mkForce (config.deps.mkShell {
      packages = [
        (config.deps.python.withPackages (ps:
          with config.mkDerivation;
            flatten [
              propagatedBuildInputs
              nativeCheckInputs
              (groupDeps "dev")
            ]))
        config.deps.pdm
      ];
    });
  };
  perSystem.pre-commit.settings.hooks.ruff.enable = true;
}
