{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  }: let
    version = self.lastModifiedDate;
    inherit (utils.lib) eachDefaultSystem;
  in
    eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages =
        {
          sakes-svgs = pkgs.stdenv.mkDerivation {
            pname = "sakes-svgs";
            inherit version;
            src = ./.;
            installPhase = ''
              mkdir -p $out
              cp *.svg $out/
            '';
          };
        }
        // {
          default = self.packages.${system}.sakes-svgs;
        };
    });
}
