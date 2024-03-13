{
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    devShells.zig = pkgs.mkShell {
      packages = [inputs'.zig.packages.master];
    };
  };
}
