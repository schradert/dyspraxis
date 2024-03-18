{
  config,
  dream2nix,
  lib,
  ...
}: let
  inherit (builtins) getAttr attrValues;
  inherit (lib.trivial) pipe;
in {
  imports = [dream2nix.modules.dream2nix.WIP-python-pdm];
  deps = {nixpkgs, ...}: {
    inherit (nixpkgs.python312.pkgs) python pytestCheckHook;
  };
  mkDerivation.src = ./.;
  mkDerivation.nativeCheckInputs =
    []
    ++ lib.lists.flatten [
      config.deps.pytestCheckHook
      (pipe config.groups.test.packages [
        attrValues
        (map (pkg:
          pipe pkg [
            attrValues
            (map (getAttr "public"))
          ]))
      ])
    ];
  mkDerivation.passthru.pre-commit.pre-commit.settings.hooks.ruff.enable = true;
  pdm.pyproject = ./pyproject.toml;
  pdm.lockfile = ./pdm.lock;
  # The existing devShell doesn't work so we must forcefully override
  # config.deps.pdm should be listed after python so its own python doesn't override our package set
  public.devShell = lib.mkForce (config.deps.mkShell {
    packages = [
      (config.deps.python.withPackages (ps: with config.mkDerivation; lib.trivial.concat propagatedBuildInputs nativeCheckInputs))
      config.deps.pdm
    ];
  });
}
