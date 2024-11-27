{
  description = "gpu-usage-waybar";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
  outputs = { self, nixpkgs }: {
    packages = {
      x86_64-linux = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        rustPlatform = pkgs.rustPlatform;
      in rustPlatform.buildRustPackage {
        pname = "gpu-usage-waybar";
        version = "0.1.12";
        src = ./.;
        cargoHash = "sha256-q8fxOetIhh1vZi/KVO+yur99yfzycizYUSdqC7cV48I=";
        meta = with pkgs.lib; {
          description = "Add GPU usage to Waybar";
          license = licenses.mit;
          maintainers = [ "Daniel Amesberger" ];
        };
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postFixup = ''
          wrapProgram $out/bin/gpu-usage-waybar \
            --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
        '';
      };
    };
    nixosModules.default = { config, ... }: {
      config.environment.systemPackages = [
        self.packages.${config.system}
      ];
    };
  };
}
