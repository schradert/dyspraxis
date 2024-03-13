{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];
  perSystem = {config, ...}: {
    pre-commit.settings.default_stages = ["push" "manual"];
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      typos.enable = true;
      commitizen.enable = true;
    };
    devShells.pre-commit = config.pre-commit.devShell;
  };
}
