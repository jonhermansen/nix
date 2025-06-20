R""(

# Examples

* Show all packages in the `nixpkgs` flake:

  ```console
  # nix search nixpkgs ^
  * legacyPackages.x86_64-linux.AMB-plugins (0.8.1)
    A set of ambisonics ladspa plugins

  * legacyPackages.x86_64-linux.ArchiSteamFarm (4.3.1.0)
    Application with primary purpose of idling Steam cards from multiple accounts simultaneously
  …
  ```

* Show packages in the `nixpkgs` flake containing `blender` in its
  name or description:

  ```console
  # nix search nixpkgs blender
  * legacyPackages.x86_64-linux.blender (2.91.0)
    3D Creation/Animation/Publishing System
  ```

* Search for packages underneath the attribute `gnome3` in Nixpkgs:

  ```console
  # nix search nixpkgs#gnome3 vala
  * legacyPackages.x86_64-linux.gnome3.vala (0.48.9)
    Compiler for GObject type system
  ```

* Show all packages in the flake in the current directory:

  ```console
  # nix search . ^
  ```

* Search for Firefox or Chromium:

  ```console
  # nix search nixpkgs 'firefox|chromium'
  ```

* Search for packages containing `git` and either `frontend` or `gui`:

  ```console
  # nix search nixpkgs git 'frontend|gui'
  ```

* Search for packages containing `neovim` but hide ones containing either `gui` or `python`:

  ```console
  # nix search nixpkgs neovim --exclude 'python|gui'
  ```
  or

  ```console
  # nix search nixpkgs neovim --exclude 'python' --exclude 'gui'
  ```

# Description

`nix search` searches [*installable*](./bsd.md#installables) that can be evaluated, that is, a
flake or Nix expression, but not a [store path] or [deriving path]) for packages whose name or description matches all of the
regular expressions *regex*. For each matching package, It prints the
full attribute name (from the root of the [installable](./bsd.md#installables)), the version
and the `meta.description` field, highlighting the substrings that
were matched by the regular expressions.

To show all packages, use the regular expression `^`. In contrast to `.*`,
it avoids highlighting the entire name and description of every package.

> Note that in this context, `^` is the regex character to match the beginning of a string, *not* the delimiter for
> [selecting a derivation output](@docroot@/command-ref/new-cli/bsd.md#derivation-output-selection).

[store path]: @docroot@/glossary.md#gloss-store-path
[deriving path]: @docroot@/glossary.md#gloss-deriving-path

# Flake output attributes

If no flake output attribute is given, `nix search` searches for
packages:

* Directly underneath `packages.<system>`.

* Underneath `legacyPackages.<system>`, recursing into attribute sets
  that contain an attribute `recurseForDerivations = true`.

)""
