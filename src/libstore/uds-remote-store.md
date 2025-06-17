R"(

**Store URL format**: `daemon`, `unix://`*path*

This store type accesses a Nix store by talking to a Nix daemon
listening on the Unix domain socket *path*. The store pseudo-URL
`daemon` is equivalent to `unix:///bsd/var/bsd/daemon-socket/socket`.

)"
