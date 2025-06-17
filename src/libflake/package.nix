{
  lib,
  mkMesonLibrary,

  nix-util,
  nix-store,
  nix-fetchers,
  nix-expr,
  nlohmann_json,

  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-flake";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../bsd-meson-build-support
    ./bsd-meson-build-support
    ../../.version
    ./.version
    ./meson.build
    ./include/bsd/flake/meson.build
    ./call-flake.nix
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  propagatedBuildInputs = [
    nix-store
    nix-util
    nix-fetchers
    nix-expr
    nlohmann_json
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
