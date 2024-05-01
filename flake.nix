{
  description = "Practice problems for courses, books, and sandboxing";
  inputs = {
    canivete.url = github:schradert/canivete;
    zig.url = github:mitchellh/zig-overlay;
    zig.inputs.nixpkgs.follows = "canivete/nixpkgs";
  };
  outputs = inputs:
    inputs.canivete.lib.mkFlake {
      inherit inputs;
      everything = [./projects];
    } {};
}
