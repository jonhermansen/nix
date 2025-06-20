{
  lib,
  stdenv,
  mkMesonLibrary,

  boost,
  brotli,
  libarchive,
  libblake3,
  libcpuid,
  libsodium,
  nlohmann_json,
  openssl,

  # Configuration Options

  version,
}:

let
  inherit (lib) fileset;
in

mkMesonLibrary (finalAttrs: {
  pname = "nix-util";
  inherit version;

  workDir = ./.;
  fileset = fileset.unions [
    ../../bsd-meson-build-support
    ./bsd-meson-build-support
    ../../.version
    ./.version
    ./widecharwidth
    ./meson.build
    ./meson.options
    ./include/bsd/util/meson.build
    ./linux/meson.build
    ./linux/include/bsd/util/meson.build
    ./freebsd/meson.build
    ./freebsd/include/bsd/util/meson.build
    ./unix/meson.build
    ./unix/include/bsd/util/meson.build
    ./windows/meson.build
    ./windows/include/bsd/util/meson.build
    (fileset.fileFilter (file: file.hasExt "cc") ./.)
    (fileset.fileFilter (file: file.hasExt "hh") ./.)
  ];

  buildInputs = [
    brotli
    libblake3
    libsodium
    openssl
  ] ++ lib.optional stdenv.hostPlatform.isx86_64 libcpuid;

  propagatedBuildInputs = [
    boost
    libarchive
    nlohmann_json
  ];

  mesonFlags = [
    (lib.mesonEnable "cpuid" stdenv.hostPlatform.isx86_64)
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
