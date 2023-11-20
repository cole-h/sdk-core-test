{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "x86_64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {

      packages = forEachSupportedSystem ({ pkgs }: rec {
        default = test;

        test = pkgs.rustPlatform.buildRustPackage {
            name = "sdk-core-test";
            src = self;
            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "rustfsm-0.1.0" = "sha256-Z7LHN6AF+bJ5Poa7cIqGQlPpX8YBmOpnDX+QqtcyRus=";
              };
            };
            nativeBuildInputs = with pkgs; [ protobuf ];
          };
      });

    };
}

