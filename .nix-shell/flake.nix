{
    description = "";

    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        nixpkgs.url = "nixpkgs/c8aa8cc00a5cb57fada0851a038d35c08a36a2bb";
        nixpkgs-unstable.url = "nixpkgs/01f116e4df6a15f4ccdffb1bcd41096869fb385c";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system:
            let
                config = { };
                pkgs = import nixpkgs {
                    inherit system config;
                    overlays = [ (final: prev: { unstable = import nixpkgs-unstable { inherit system config; }; }) ];
                };
            in with pkgs; {
                    devShells.default = mkShell {
                        buildInputs = [
                          # NOTE: add packages here
                            go gopls gomodifytags unstable.delve
                            (buildGoModule rec {
                                name = "bootdev";
                                version= "1.20.5";
                                src = fetchFromGitHub {
                                  owner = "bootdotdev";
                                  repo = "bootdev";
                                  rev = "v${version}";
                                  hash = "sha256-iVL2nRQb4A7UfhiQSBBbaxM1Yqc2pESvRfQ3xSjGq10=";
                                };
                                vendorHash = "sha256-jhRoPXgfntDauInD+F7koCaJlX4XDj+jQSe/uEEYIMM=";
                            })
                        ];
                    };
                });
}
