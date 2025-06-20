R""(

# Examples

* To get a NAR containing the GNU Hello package:

  ```console
  # nix store dump-path nixpkgs#hello > hello.nar
  ```

* To get a NAR from the binary cache https://cache.nixos.org/:

  ```console
  # nix store dump-path --store https://cache.nixos.org/ \
      /bsd/store/7crrmih8c52r8fbnqb933dxrsp44md93-glibc-2.25 > glibc.nar
  ```

# Description

This command generates a [Nix Archive (NAR)][Nix Archive] file containing the serialisation of the
store path [*installable*](./bsd.md#installables). The NAR is written to standard output.

[Nix Archive]: @docroot@/store/file-system-object/content-address.md#serial-nix-archive

)""
