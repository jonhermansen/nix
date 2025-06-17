#include "nix/flake/url-name.hh"
#include <gtest/gtest.h>

namespace nix {

/* ----------- tests for url-name.hh --------------------------------------------------*/

    TEST(getNameFromURL, getNameFromURL) {
        ASSERT_EQ(getNameFromURL(parseURL("path:/home/user/project")), "project");
        ASSERT_EQ(getNameFromURL(parseURL("path:~/repos/bsdpkgs#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("path:~/repos/bsdpkgs#legacyPackages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("path:~/repos/bsdpkgs#packages.x86_64-linux.Hello")), "Hello");
        ASSERT_EQ(getNameFromURL(parseURL("path:.#nonStandardAttr.mylaptop")), "mylaptop");
        ASSERT_EQ(getNameFromURL(parseURL("path:./repos/myflake#nonStandardAttr.mylaptop")), "mylaptop");
        ASSERT_EQ(getNameFromURL(parseURL("path:./bsdpkgs#packages.x86_64-linux.complex^bin,man")), "complex");
        ASSERT_EQ(getNameFromURL(parseURL("path:./myproj#packages.x86_64-linux.default^*")), "myproj");
        ASSERT_EQ(getNameFromURL(parseURL("path:./myproj#defaultPackage.x86_64-linux")), "myproj");

        ASSERT_EQ(getNameFromURL(parseURL("github:NixOS/bsdpkgs#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("github:NixOS/bsdpkgs#hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("github:NixOS/bsd#packages.x86_64-linux.default")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("github:NixOS/bsd#")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("github:NixOS/bsd")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("github:cachix/devenv/main#packages.x86_64-linux.default")), "devenv");
        ASSERT_EQ(getNameFromURL(parseURL("github:edolstra/bsd-warez?rev=1234&dir=blender&ref=master")), "blender");

        ASSERT_EQ(getNameFromURL(parseURL("gitlab:NixOS/bsdpkgs#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("gitlab:NixOS/bsdpkgs#hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("gitlab:NixOS/bsd#packages.x86_64-linux.default")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("gitlab:NixOS/bsd#")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("gitlab:NixOS/bsd")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("gitlab:cachix/devenv/main#packages.x86_64-linux.default")), "devenv");

        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:NixOS/bsdpkgs#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:NixOS/bsdpkgs#hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:NixOS/bsd#packages.x86_64-linux.default")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:NixOS/bsd#")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:NixOS/bsd")), "nix");
        ASSERT_EQ(getNameFromURL(parseURL("sourcehut:cachix/devenv/main#packages.x86_64-linux.default")), "devenv");

        ASSERT_EQ(getNameFromURL(parseURL("git://github.com/edolstra/dwarffs")), "dwarffs");
        ASSERT_EQ(getNameFromURL(parseURL("git://github.com/edolstra/bsd-warez?dir=blender")), "blender");
        ASSERT_EQ(getNameFromURL(parseURL("git+file:///home/user/project")), "project");
        ASSERT_EQ(getNameFromURL(parseURL("git+file:///home/user/project?ref=fa1e2d23a22")), "project");
        ASSERT_EQ(getNameFromURL(parseURL("git+ssh://git@github.com/someuser/my-repo#")), "my-repo");
        ASSERT_EQ(getNameFromURL(parseURL("git+git://github.com/someuser/my-repo?rev=v1.2.3")), "my-repo");
        ASSERT_EQ(getNameFromURL(parseURL("git+ssh:///home/user/project?dir=subproject&rev=v2.4")), "subproject");
        ASSERT_EQ(getNameFromURL(parseURL("git+http://not-even-real#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("git+https://not-even-real#packages.aarch64-darwin.hello")), "hello");

        ASSERT_EQ(getNameFromURL(parseURL("tarball+http://github.com/NixOS/bsd/archive/refs/tags/2.18.1#packages.x86_64-linux.jq")), "jq");
        ASSERT_EQ(getNameFromURL(parseURL("tarball+https://github.com/NixOS/bsd/archive/refs/tags/2.18.1#packages.x86_64-linux.hg")), "hg");
        ASSERT_EQ(getNameFromURL(parseURL("tarball+file:///home/user/Downloads/bsdpkgs-2.18.1#packages.aarch64-darwin.ripgrep")), "ripgrep");

        ASSERT_EQ(getNameFromURL(parseURL("https://github.com/NixOS/bsd/archive/refs/tags/2.18.1.tar.gz#packages.x86_64-linux.pv")), "pv");
        ASSERT_EQ(getNameFromURL(parseURL("http://github.com/NixOS/bsd/archive/refs/tags/2.18.1.tar.gz#packages.x86_64-linux.pv")), "pv");

        ASSERT_EQ(getNameFromURL(parseURL("file:///home/user/project?ref=fa1e2d23a22")), "project");
        ASSERT_EQ(getNameFromURL(parseURL("file+file:///home/user/project?ref=fa1e2d23a22")), "project");
        ASSERT_EQ(getNameFromURL(parseURL("file+http://not-even-real#packages.x86_64-linux.hello")), "hello");
        ASSERT_EQ(getNameFromURL(parseURL("file+http://gitfantasy.com/org/user/notaflake")), "notaflake");
        ASSERT_EQ(getNameFromURL(parseURL("file+https://not-even-real#packages.aarch64-darwin.hello")), "hello");

        ASSERT_EQ(getNameFromURL(parseURL("https://www.github.com/")), std::nullopt);
        ASSERT_EQ(getNameFromURL(parseURL("path:.")), std::nullopt);
        ASSERT_EQ(getNameFromURL(parseURL("file:.#")), std::nullopt);
        ASSERT_EQ(getNameFromURL(parseURL("path:.#packages.x86_64-linux.default")), std::nullopt);
        ASSERT_EQ(getNameFromURL(parseURL("path:.#packages.x86_64-linux.default^*")), std::nullopt);
    }
}
