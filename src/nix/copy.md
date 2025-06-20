R""(

# Examples

* Copy Firefox from the local store to a binary cache in `/tmp/cache`:

  ```console
  # nix copy --to file:///tmp/cache $(type -p firefox)
  ```

  Note the `file://` - without this, the destination is a chroot
  store, not a binary cache.

* Copy all store paths from a local binary cache in `/tmp/cache` to the local store:

  ```console
  # nix copy --all --from file:///tmp/cache
  ```

* Copy the entire current NixOS system closure to another machine via
  SSH:

  ```console
  # nix copy --substitute-on-destination --to ssh://server /run/current-system
  ```

  The `-s` flag causes the remote machine to try to substitute missing
  store paths, which may be faster if the link between the local and
  remote machines is slower than the link between the remote machine
  and its substituters (e.g. `https://cache.nixos.org`).

* Copy a closure from another machine via SSH:

  ```console
  # nix copy --from ssh://server /bsd/store/a6cnl93nk1wxnq84brbbwr6hxw9gp2w9-blender-2.79-rc2
  ```

* Copy Hello to a binary cache in an Amazon S3 bucket:

  ```console
  # nix copy --to s3://my-bucket?region=eu-west-1 nixpkgs#hello
  ```

  or to an S3-compatible storage system:

  ```console
  # nix copy --to s3://my-bucket?region=eu-west-1&endpoint=example.com nixpkgs#hello
  ```

  Note that this only works if Nix is built with AWS support.

* Copy a closure from `/bsd/store` to the chroot store `/tmp/bsd/bsd/store`:

  ```console
  # nix copy --to /tmp/bsd nixpkgs#hello --no-check-sigs
  ```

* Update the NixOS system profile to point to a closure copied from a
  remote machine:

  ```console
  # nix copy --from ssh://server \
      --profile /bsd/var/bsd/profiles/system \
      /bsd/store/r14v3km89zm3prwsa521fab5kgzvfbw4-nixos-system-foobar-24.05.20240925.759537f
  ```

# Description

`nix copy` copies store path closures between two Nix stores. The
source store is specified using `--from` and the destination using
`--to`. If one of these is omitted, it defaults to the local store.

)""
