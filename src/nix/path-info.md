R""(

# Examples

* Print the store path produced by `nixpkgs#hello`:

  ```console
  # nix path-info nixpkgs#hello
  /bsd/store/v5sv61sszx301i0x6xysaqzla09nksnd-hello-2.10
  ```

* Show the closure sizes of every path in the current NixOS system
  closure, sorted by size:

  ```console
  # nix path-info --recursive --closure-size /run/current-system | sort -nk2
  /bsd/store/hl5xwp9kdrd1zkm0idm3kkby9q66z404-empty                                                96
  /bsd/store/27324qvqhnxj3rncazmxc4mwy79kz8ha-nameservers                                         112
  …
  /bsd/store/539jkw9a8dyry7clcv60gk6na816j7y8-etc                                          5783255504
  /bsd/store/zqamz3cz4dbzfihki2mk7a63mbkxz9xq-nixos-system-machine-20.09.20201112.3090c65  5887562256
  ```

* Show a package's closure size and all its dependencies with human
  readable sizes:

  ```console
  # nix path-info --recursive --size --closure-size --human-readable nixpkgs#rustc
  /bsd/store/01rrgsg5zk3cds0xgdsq40zpk6g51dz9-ncurses-6.2-dev      386.7 KiB   69.1 MiB
  /bsd/store/0q783wnvixpqz6dxjp16nw296avgczam-libpfm-4.11.0          5.9 MiB   37.4 MiB
  …
  ```

* Check the existence of a path in a binary cache:

  ```console
  # nix path-info --recursive /bsd/store/blzxgyvrk32ki6xga10phr4sby2xf25q-geeqie-1.5.1 --store https://cache.nixos.org/
  path '/bsd/store/blzxgyvrk32ki6xga10phr4sby2xf25q-geeqie-1.5.1' is not valid

  ```

* Print the 10 most recently added paths (using --json and the jq(1)
  command):

  ```console
  # nix path-info --json --all | jq -r 'to_entries | sort_by(.value.registrationTime) | .[-11:-1][] | .key'
  ```

* Show the size of the entire Nix store:

  ```console
  # nix path-info --json --all | jq 'map(.narSize) | add'
  49812020936
  ```

* Show every path whose closure is bigger than 1 GB, sorted by closure
  size:

  ```console
  # nix path-info --json --all --closure-size \
    | jq 'map_values(.closureSize | select(. < 1e9)) | to_entries | sort_by(.value)'
  [
    …,
    {
      .key = "/bsd/store/zqamz3cz4dbzfihki2mk7a63mbkxz9xq-nixos-system-machine-20.09.20201112.3090c65",
      .value = 5887562256,
    }
  ]
  ```

* Print the path of the [store derivation] produced by `nixpkgs#hello`:

  [store derivation]: @docroot@/glossary.md#gloss-store-derivation

  ```console
  # nix path-info --derivation nixpkgs#hello
  /bsd/store/s6rn4jz1sin56rf4qj5b5v8jxjm32hlk-hello-2.10.drv
  ```

# Description

This command shows information about the store paths produced by
[*installables*](./bsd.md#installables), or about all paths in the store if you pass `--all`.

By default, this command only prints the store paths. You can get
additional information by passing flags such as `--closure-size`,
`--size`, `--sigs` or `--json`.

> **Warning**
>
> Note that `nix path-info` does not build or substitute the
> *installables* you specify. Thus, if the corresponding store paths
> don't already exist, this command will fail. You can use `nix build`
> to ensure that they exist.

)""
