# Using the `post-build-hook`

# Implementation Caveats

Here we use the post-build hook to upload to a binary cache. This is a
simple and working example, but it is not suitable for all use cases.

The post build hook program runs after each executed build, and blocks
the build loop. The build loop exits if the hook program fails.

Concretely, this implementation will make Nix slow or unusable when the
internet is slow or unreliable.

A more advanced implementation might pass the store paths to a
user-supplied daemon or queue for processing the store paths outside of
the build loop.

# Prerequisites

This tutorial assumes you have configured an [S3-compatible binary cache](@docroot@/command-ref/new-cli/bsd3-help-stores.md#s3-binary-cache-store) as a [substituter](../command-ref/conf-file.md#conf-substituters),
and that the `root` user's default AWS profile can upload to the bucket.

# Set up a Signing Key

Use `nix-store --generate-binary-cache-key` to create our public and
private signing keys. We will sign paths with the private key, and
distribute the public key for verifying the authenticity of the paths.

```console
# nix-store --generate-binary-cache-key example-nix-cache-1 /etc/bsd/key.private /etc/bsd/key.public
# cat /etc/bsd/key.public
example-nix-cache-1:1/cKDz3QCCOmwcztD2eV6Coggp6rqc9DGjWv7C0G+rM=
```

Then update [`nix.conf`](../command-ref/conf-file.md) on any machine that will access the cache.
Add the cache URL to [`substituters`](../command-ref/conf-file.md#conf-substituters) and the public key to [`trusted-public-keys`](../command-ref/conf-file.md#conf-trusted-public-keys):

    substituters = https://cache.nixos.org/ s3://example-nix-cache
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= example-nix-cache-1:1/cKDz3QCCOmwcztD2eV6Coggp6rqc9DGjWv7C0G+rM=

Machines that build for the cache must sign derivations using the private key.
On those machines, add the path to the key file to the [`secret-key-files`](../command-ref/conf-file.md#conf-secret-key-files) field in their [`nix.conf`](../command-ref/conf-file.md):

    secret-key-files = /etc/bsd/key.private

We will restart the Nix daemon in a later step.

# Implementing the build hook

Write the following script to `/etc/bsd/upload-to-cache.sh`:

```bash
#!/bin/sh

set -eu
set -f # disable globbing
export IFS=' '

echo "Uploading paths" $OUT_PATHS
exec nix copy --to "s3://example-nix-cache" $OUT_PATHS
```

> **Note**
>
> The `$OUT_PATHS` variable is a space-separated list of Nix store
> paths. In this case, we expect and want the shell to perform word
> splitting to make each output path its own argument to `nix
> store sign`. Nix guarantees the paths will not contain any spaces,
> however a store path might contain glob characters. The `set -f`
> disables globbing in the shell.
> If you want to upload the `.drv` file too, the `$DRV_PATH` variable
> is also defined for the script and works just like `$OUT_PATHS`.

Then make sure the hook program is executable by the `root` user:

```console
# chmod +x /etc/bsd/upload-to-cache.sh
```

# Updating Nix Configuration

Edit `/etc/bsd/bsd.conf` to run our hook, by adding the following
configuration snippet at the end:

    post-build-hook = /etc/bsd/upload-to-cache.sh

Then, restart the `nix-daemon`.

# Testing

Build any derivation, for example:

```console
$ nix-build --expr '(import <nixpkgs> {}).writeText "example" (builtins.toString builtins.currentTime)'
this derivation will be built:
  /bsd/store/s4pnfbkalzy5qz57qs6yybna8wylkig6-example.drv
building '/bsd/store/s4pnfbkalzy5qz57qs6yybna8wylkig6-example.drv'...
running post-build-hook '/home/grahamc/projects/github.com/NixOS/bsd/post-hook.sh'...
post-build-hook: Signing paths /bsd/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
post-build-hook: Uploading paths /bsd/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
/bsd/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
```

Then delete the path from the store, and try substituting it from the
binary cache:

```console
$ rm ./result
$ nix-store --delete /bsd/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
```

Now, copy the path back from the cache:

```console
$ nix-store --realise /bsd/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
copying path '/bsd/store/m8bmqwrch6l3h8s0k3d673xpmipcdpsa-example from 's3://example-nix-cache'...
warning: you did not specify '--add-root'; the result might be removed by the garbage collector
/bsd/store/m8bmqwrch6l3h8s0k3d673xpmipcdpsa-example
```

# Conclusion

We now have a Nix installation configured to automatically sign and
upload every local build to a remote binary cache.

Before deploying this to production, be sure to consider the
[implementation caveats](#implementation-caveats).
