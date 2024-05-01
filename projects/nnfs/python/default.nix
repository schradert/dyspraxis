{
  perSystem = {
    nix,
    self',
    ...
  }:
    with nix; {
      canivete.dream2nix.packages.nnfspy.module = {
        config,
        dream2nix,
        ...
      }: let
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
          inherit (nixpkgs) git;
          inherit (nixpkgs.python312.pkgs) python pytestCheckHook;
        };
        mkDerivation.src = ./.;
        mkDerivation.nativeCheckInputs = concat (groupDeps "test") [config.deps.pytestCheckHook];
        pdm.pyproject = ./pyproject.toml;
        pdm.lockfile = ./pdm.lock;
        # The existing devShell doesn't work so we must forcefully override
        # config.deps.pdm should be listed after python so its own python doesn't override our package set
        public.devShell = let
          python = config.deps.python.withPackages (_:
            with config.mkDerivation;
              flatten [
                propagatedBuildInputs
                nativeCheckInputs
                (groupDeps "dev")
              ]);
        in
          mkForce (config.deps.mkShell {
            packages = [
              python
              config.deps.pdm
            ];
            shellHook = ''
              root="$(${config.deps.git}/bin/git rev-parse --show-toplevel)"
              export PDM_PYTHON=${python}/bin/python
              eval "$(${config.deps.pdm}/bin/pdm --pep582 "$(basename "$SHELL")")"
            '';
          });
        paths.package = ./.;
      };
      # TODO why does this give partial evaluation error?
      pre-commit.settings.hooks.ruff = {
        enable = true;
        entry = mkForce "${self'.packages.nnfspy.config.groups.dev.packages.ruff."0.3.3".public}/bin/ruff check --fix";
      };
    };
}
