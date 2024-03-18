{
  inputs,
  lib,
  ...
}: {
  options.flake.dream2nixModules = with lib;
    mkOption {
      type = with types; attrsOf deferredModule;
      default = {};
      description = mdDoc "Dream2Nix modules for each project package";
      example = {dream2nix, ...}: {
        imports = [dream2nix.modules.dream2nix.mkDerivation];
        mkDerivation.src = ./.;
      };
    };
  config.perSystem = {pkgs, ...}: {
    packages = builtins.mapAttrs (name: module:
      inputs.dream2nix.lib.evalModules {
        modules = [
          module
          {
            paths.projectRoot = toString inputs.self;
            paths.projectRootFile = "flake.nix";
            paths.package = dirOf module._file;
          }
        ];
        packageSets.nixpkgs = pkgs;
      })
    inputs.self.dream2nixModules;
  };
}
