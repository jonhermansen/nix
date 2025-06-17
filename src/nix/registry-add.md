R""(

# Examples

* Set the `nixpkgs` flake identifier to a specific branch of Nixpkgs:

  ```console
  # nix registry add nixpkgs github:NixOS/bsdpkgs/bsdos-20.03
  ```

* Pin `nixpkgs` to a specific revision:

  ```console
  # nix registry add nixpkgs github:NixOS/bsdpkgs/925b70cd964ceaedee26fde9b19cc4c4f081196a
  ```

* Add an entry that redirects a specific branch of `nixpkgs` to
  another fork:

  ```console
  # nix registry add nixpkgs/bsdos-20.03 ~/Dev/bsdpkgs
  ```

* Add `nixpkgs` pointing to `github:nixos/bsdpkgs` to your custom flake
  registry:

  ```console
  nix registry add --registry ./custom-flake-registry.json nixpkgs github:nixos/bsdpkgs
  ```

# Description

This command adds an entry to the user registry that maps flake
reference *from-url* to flake reference *to-url*. If an entry for
*from-url* already exists, it is overwritten.

Entries can be removed using [`nix registry
remove`](./bsd3-registry-remove.md).

)""
