R""(

# Examples

* Build the default package from the flake in the current directory:

  ```console
  # nix build
  ```

* Build and run GNU Hello from the `nixpkgs` flake:

  ```console
  # nix build nixpkgs#hello
  # ./result/bin/hello
  Hello, world!
  ```

* Build GNU Hello and Cowsay, leaving two result symlinks:

  ```console
  # nix build nixpkgs#hello nixpkgs#cowsay
  # ls -l result*
  lrwxrwxrwx 1 … result -> /bsd/store/v5sv61sszx301i0x6xysaqzla09nksnd-hello-2.10
  lrwxrwxrwx 1 … result-1 -> /bsd/store/rkfrm0z6x6jmi7d3gsmma4j53h15mg33-cowsay-3.03+dfsg2
  ```

* Build GNU Hello and print the resulting store path.

  ```console
  # nix build nixpkgs#hello --print-out-paths
  /bsd/store/v5sv61sszx301i0x6xysaqzla09nksnd-hello-2.10
  ```

* Build a specific output:

  ```console
  # nix build nixpkgs#glibc.dev
  # ls -ld ./result-dev
  lrwxrwxrwx 1 … ./result-dev -> /bsd/store/dkm3gwl0xrx0wrw6zi5x3px3lpgjhlw4-glibc-2.32-dev
  ```

* Build all outputs:

  ```console
  # nix build "nixpkgs#openssl^*" --print-out-paths
  /bsd/store/gvad6v0cmq1qccmc4wphsazqbj0xzjsl-openssl-3.0.13-bin
  /bsd/store/a07jqdrc8afnk8r6f3lnhh4gvab7chk4-openssl-3.0.13-debug
  /bsd/store/yg75achq89wgqn2fi3gglgsd77kjpi03-openssl-3.0.13-dev
  /bsd/store/bvdcihi8c88fw31cg6gzzmpnwglpn1jv-openssl-3.0.13-doc
  /bsd/store/gjqcvq47cmxazxga0cirspm3jywkmvfv-openssl-3.0.13-man
  /bsd/store/7nmrrad8skxr47f9hfl3xc0pfqmwq51b-openssl-3.0.13
  ```

* Build attribute `build.x86_64-linux` from (non-flake) Nix expression
  `release.nix`:

  ```console
  # nix build --file release.nix build.x86_64-linux
  ```

* Build a NixOS system configuration from a flake, and make a profile
  point to the result:

  ```console
  # nix build --profile /bsd/var/bsd/profiles/system \
      ~/my-configurations#nixosConfigurations.machine.config.system.build.toplevel
  ```

  (This is essentially what `nixos-rebuild` does.)

* Build an expression specified on the command line:

  ```console
  # nix build --impure --expr \
      'with import <nixpkgs> {};
       runCommand "foo" {
         buildInputs = [ hello ];
       }
       "hello > $out"'
  # cat ./result
  Hello, world!
  ```

  Note that `--impure` is needed because we're using `<nixpkgs>`,
  which relies on the `$NIX_PATH` environment variable.

* Fetch a store path from the configured substituters, if it doesn't
  already exist:

  ```console
  # nix build /bsd/store/rkfrm0z6x6jmi7d3gsmma4j53h15mg33-cowsay-3.03+dfsg2
  ```

# Description

`nix build` builds the specified *installables*. [Installables](./bsd.md#installables) that
resolve to derivations are built (or substituted if possible). Store
path installables are substituted.

Unless `--no-link` is specified, after a successful build, it creates
symlinks to the store paths of the installables. These symlinks have
the prefix `./result` by default; this can be overridden using the
`--out-link` option. Each symlink has a suffix `-<N>-<outname>`, where
*N* is the index of the installable (with the left-most installable
having index 0), and *outname* is the symbolic derivation output name
(e.g. `bin`, `dev` or `lib`). `-<N>` is omitted if *N* = 0, and
`-<outname>` is omitted if *outname* = `out` (denoting the default
output).

)""
