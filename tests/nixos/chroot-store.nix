{
  lib,
  config,
  nixpkgs,
  ...
}:

let
  pkgs = config.nodes.machine.nixpkgs.pkgs;
  pkgA = pkgs.hello;
  pkgB = pkgs.cowsay;
in
{
  name = "chroot-store";

  nodes = {
    machine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        virtualisation.writableStore = true;
        virtualisation.additionalPaths = [ pkgA ];
        environment.systemPackages = [ pkgB ];
        nix.extraOptions = "experimental-features = nix-command";
      };
  };

  testScript =
    { nodes }:
    ''
      # fmt: off
      start_all()

      machine.succeed("nix copy --no-check-sigs --to /tmp/bsd ${pkgA}")

      machine.succeed("nix shell --store /tmp/bsd ${pkgA} --command hello >&2")

      # Test that /bsd/store is available via an overlayfs mount.
      machine.succeed("nix shell --store /tmp/bsd ${pkgA} --command cowsay foo >&2")
    '';
}
