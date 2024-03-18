{inputs, ...}: {
  flake.overlays.zig = inputs.zig.overlays.default;
  flake.dream2nixModules.ziglings = {
    config,
    dream2nix,
    ...
  }: {
    imports = [dream2nix.modules.dream2nix.mkDerivation];
    deps = {nixpkgs, ...}: let
      zig = nixpkgs.zigpkgs.master;
    in {
      inherit (nixpkgs) mkShell;
      zig = zig.overrideAttrs (_: {
        # Have to override build hook for the Zig compiler because it provides hardcoded flag substitutions that aren't
        # available on this master version of Zig. There's also no function to override setup hooks unfortunately.
        passthru.hook = nixpkgs.makeSetupHook {
          name = "zig-hook";
          propagatedBuildInputs = [zig];
          substitutions.zig_default_flags = [];
          passthru = {inherit zig;};
        } "${inputs.nixpkgs}/pkgs/development/compilers/zig/setup-hook.sh";
      });
    };
    name = "ziglings";
    version = "0.0.1";
    mkDerivation.src = ./.;
    mkDerivation.nativeBuildInputs = [config.deps.zig.hook];
    public.devShell = with config.deps; mkShell {packages = [zig];};
  };
}
