{
  description = "gpu-usage-waybar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      rustPlatform = pkgs.rustPlatform;
    in {
      # Package definition
      packages.default = rustPlatform.buildRustPackage {
        pname = "gpu-usage-waybar";
        version = "0.1.12";

        # Include the entire directory as the source
        src = ./.;

        # Replace cargoSha256 with cargoHash
        cargoHash = "sha256-68uQNqa8vrKzYrt/Wmf7cNnLNSRa6GGT7OZDd8hJ4HU=";

        meta = with pkgs.lib; {
          description = "Add GPU usage to Waybar";
          license = licenses.mit;
          maintainers = [ "Daniel Amesberger" ];
        };
      };

      # NixOS module definition
      nixosModules.rustProject = { config, pkgs, ... }: {
        config = {
          environment.systemPackages = [ self.packages.${system}.default ];
          environment.variables.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
        };
      };
    });
}
