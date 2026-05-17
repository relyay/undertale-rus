{
  description = "Undertale Rus Installer for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.rusifier =
        pkgs.buildFHSEnv {
          name = "undertale-rus-installer";

          targetPkgs = pkgs: with pkgs; [
            icu
            libgdiplus
            cairo
            fontconfig
            freetype
            libpng
            libjpeg
            libtiff
            giflib
            glib
            zlib
            harfbuzz
            pixman
          ];

          runScript = pkgs.writeShellScript "run-rusifier" ''
            cd "${./data}"
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
              pkgs.icu
              pkgs.libgdiplus
              pkgs.cairo
              pkgs.fontconfig
              pkgs.freetype
              pkgs.libpng
            ]}:$LD_LIBRARY_PATH

            exec ./UndertaleRusInstaller
          '';
        };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.rusifier}/bin/undertale-rus-installer";
      };
    };
}
