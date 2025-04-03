{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      forEachSystem =
        f:
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "aarch64-linux" ] (
          system: f { pkgs = import nixpkgs { inherit system; }; }
        );
    in
    {
      packages = forEachSystem (
        { pkgs }:
        rec {
          default = zed;
          zed = pkgs.callPackage ./package.nix { inherit lib; };
        }
      );
    };
}
