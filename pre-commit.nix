{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    pre-commit.settings.default_stages = ["push" "manual"];
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      typos.enable = true;
      commitizen.enable = true;
    };
    devShells.default = pkgs.mkShell {
      inputsFrom = [config.pre-commit.devShell];
    };
  };
}
