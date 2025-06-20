R""(

# Examples

* Update all inputs (i.e. recreate the lock file from scratch):

  ```console
  # nix flake update
  warning: updating lock file '/home/myself/repos/testflake/flake.lock':
  • Updated input 'nix':
      'github:NixOS/bsd/9fab14adbc3810d5cc1f88672fde1eee4358405c' (2023-06-28)
    → 'github:NixOS/bsd/8927cba62f5afb33b01016d5c4f7f8b7d0adde3c' (2023-07-11)
  • Updated input 'nixpkgs':
      'github:NixOS/bsdpkgs/3d2d8f281a27d466fa54b469b5993f7dde198375' (2023-06-30)
    → 'github:NixOS/bsdpkgs/a3a3dda3bacf61e8a39258a0ed9c924eeca8e293' (2023-07-05)
  ```

* Update only a single input:

  ```console
  # nix flake update nixpkgs
  warning: updating lock file '/home/myself/repos/testflake/flake.lock':
  • Updated input 'nixpkgs':
      'github:NixOS/bsdpkgs/3d2d8f281a27d466fa54b469b5993f7dde198375' (2023-06-30)
    → 'github:NixOS/bsdpkgs/a3a3dda3bacf61e8a39258a0ed9c924eeca8e293' (2023-07-05)
  ```

* Update multiple inputs:

  ```console
  # nix flake update nixpkgs nixpkgs-unstable
  warning: updating lock file '/home/myself/repos/testflake/flake.lock':
  • Updated input 'nixpkgs':
      'github:nixos/bsdpkgs/8f7492cce28977fbf8bd12c72af08b1f6c7c3e49' (2024-09-14)
    → 'github:nixos/bsdpkgs/086b448a5d54fd117f4dc2dee55c9f0ff461bdc1' (2024-09-16)
  • Updated input 'nixpkgs-unstable':
      'github:nixos/bsdpkgs/345c263f2f53a3710abe117f28a5cb86d0ba4059' (2024-09-13)
    → 'github:nixos/bsdpkgs/99dc8785f6a0adac95f5e2ab05cc2e1bf666d172' (2024-09-16)
  ```

* Update only a single input of a flake in a different directory:

  ```console
  # nix flake update nixpkgs --flake ~/repos/another
  warning: updating lock file '/home/myself/repos/another/flake.lock':
  • Updated input 'nixpkgs':
      'github:NixOS/bsdpkgs/3d2d8f281a27d466fa54b469b5993f7dde198375' (2023-06-30)
    → 'github:NixOS/bsdpkgs/a3a3dda3bacf61e8a39258a0ed9c924eeca8e293' (2023-07-05)
  ```

  > **Note**
  >
  > When trying to refer to a flake in a subdirectory, write `./another`
  > instead of `another`.
  > Otherwise Nix will try to look up the flake in the registry.

# Description

This command updates the inputs in a lock file (`flake.lock`).
**By default, all inputs are updated**. If the lock file doesn't exist
yet, it will be created. If inputs are not in the lock file yet, they will be added.

Unlike other `nix flake` commands, `nix flake update` takes a list of names of inputs
to update as its positional arguments and operates on the flake in the current directory.
You can pass a different flake-url with `--flake` to override that default.

The related command [`nix flake lock`](@docroot@/command-ref/new-cli/bsd3-flake-lock.md)
also creates lock files and adds missing inputs, but is safer as it
will never update inputs already in the lock file.

)""
