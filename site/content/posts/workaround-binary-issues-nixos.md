---
title: "Workaround Binary Issues NixOS"
date: 2023-11-21T00:11:19+07:00
draft: false
toc: false
images:
categories:
  - explanation
  - tutorial
tags:
  - untagged
---

I think everyone who uses NixOS should have encountered this dreaded error (I'm
using a "random" binary file that comes from Codeium, which is an code
completion extension powered by AI):

```shell
./language_server_linux_x64
# zsh: no such file or directory: ./language_server_linux_x64
```

It is quite elusive on why does this happen. After taking a while searching and
reading, I "sort of" understood the problem, but can only put it to my terms
like this: in other OSes (Ubuntu for example), C libraries can be found using a
global `PATH`, while NixOS does not have the same semantic; it leads to the
problem that compiled binaries cannot find the C libraries they need. 

In fact, if we use `ldd` on the binary, it should be clear what is missing:

```shell
ldd language_server_linux_x64
# linux-vdso.so.1 (0x00007fff22be5000)
# libm.so.6 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib/libm.so.6 (0x00007f723eebd000)
# libdl.so.2 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib/libdl.so.2 (0x00007f723eeb8000)
# libresolv.so.2 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib/libresolv.so.2 (0x00007f723eea5000)
# libpthread.so.0 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib/libpthread.so.0 (0x00007f723eea0000)
# libc.so.6 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib/libc.so.6 (0x00007f723ecba000)
# /lib64/ld-linux-x86-64.so.2 => /nix/store/46m4xx889wlhsdj72j38fnlyyvvvvbyb-glibc-2.37-8/lib64/ld-linux-x86-64.so.2 (0x00007f723ef9f000)
```

In my case, `linux-vdso.so.1` was missing, which makes the shell raises a
seemingly unrelated message like that.

The approaches to solve this apparently always revolves around making sure that
the compiled binary can find the C libraries. The most inefficient way to do it
is to manually appending those libraries' paths to `PATH`. There are a few
related tools: `nix-alien`, `nix-autobahn`, etc.

For example, using `nix-alien` to run the binary above would be:

```
nix-alien language_server_linux_x64
# [nix-alien] File '/home/thanh/.cache/nix-alien/ae80f7c2-f67d-596e-bc4c-0bd3dd7e200a/fhs-env/default.nix' created successfuly!
# these 3 derivations will be built:
#   /nix/store/q6p50ix2ss6w8i3qv4zhavk2asx0hmhw-language_server_linux_x64-fhs-init.drv
#   /nix/store/jxw2pn2kdlwc9xzz5jpaa8cw3p0rqmj5-language_server_linux_x64-fhs-bwrap.drv
#   /nix/store/d2gs0x5zv9bn42s0fiw6d8p7jg63gi4p-language_server_linux_x64-fhs.drv
# building '/nix/store/q6p50ix2ss6w8i3qv4zhavk2asx0hmhw-language_server_linux_x64-fhs-init.drv'...
# building '/nix/store/jxw2pn2kdlwc9xzz5jpaa8cw3p0rqmj5-language_server_linux_x64-fhs-bwrap.drv'...
# building '/nix/store/d2gs0x5zv9bn42s0fiw6d8p7jg63gi4p-language_server_linux_x64-fhs.drv'...
# I1121 00:35:58.347109 3441808 main.go:526] Starting language server manager with pid 3441808
# I1121 00:35:58.348093 3441808 main.go:292] Language server manager attempting to connect to language server at 127.0.0.1:42100
# I1121 00:35:58.631177 3441820 main.go:520] Starting language server process with pid 3441820
# ...
```

However, it doesn't really solve my problem since the binary would be started by
another program, and I cannot really "patch" that program to run `nix-alien
my-binary` instead of `my-binary`.

I got stuck for a while, but then finally found a way to do it:

1. Use `nix-alien` to generate the `default.nix` file
2. Build a fully working binary from that `default.nix`
3. Use the built binary to replace the original binary

Demonstrating with the binary above, it would be running this command for step
1:

```shell
nix-alien -r -d . language_server_linux_x64
```

After that, we can find `default.nix` in the same directory:

```nix
{ pkgs ? import
    (builtins.fetchTarball {
      name = "nixpkgs-unstable-20231026110141";
      url = "https://github.com/NixOS/nixpkgs/archive/63678e9f3d3afecfeafa0acead6239cdb447574c.tar.gz";
      sha256 = "sha256-gUihHt3yPD7bVqg+k/UVHgngyaJ3DMEBchbymBMvK1E=";
    })
    { }
}:

let
  inherit (pkgs) buildFHSUserEnv;
in
buildFHSUserEnv {
  name = "language_server_linux_x64_original-fhs";
  targetPkgs = p: with p; [

  ];
  runScript = "/home/thanh/.local/share/JetBrains/WebStorm2023.1/codeium/24a3d58b54b2e4df9d1281d09dd1f8818fe4b519/language_server_linux_x64";
}
```

Then we can move to step 2:

```shell
nix-build default.nix
```

Which would create a folder named `result` in the same directory. Getting into
it, we can find a folder named `bin` that has another binary named
`language_server_linux_x64-fhs`.

```shell
cd result/bin
ls
# language_server_linux_x64-fhs
```

If we try running it, it would also work as expected:

```shell
./language_server_linux_x64-fhs
# I1121 00:45:10.923724 3460024 main.go:526] Starting language server manager with pid 3460024
# I1121 00:45:10.924205 3460024 main.go:292] Language server manager attempting to connect to language server at 127.0.0.1:42100
# I1121 00:45:11.085100 3460036 main.go:520] Starting language server process with pid 3460036
# I1121 00:45:11.085546 3460036 proxy.go:93] proxyplease.proxy> No proxy provided. Attempting to infer from system.
# I1121 00:45:11.085563 3460036 proxy.go:93] proxyplease.proxy> No proxy could be determined. Assuming a direct connection.
# I1121 00:45:11.085604 3460036 client.go:589] [DEBUG] GET http://0.0.0.0:50001/exa.api_server_pb.ApiServerService/GetCompletions
# ...
```

We move back to the original folder, rename the original file, and then copy the
built binary here:

```shell
mv language_server_linux_x64 language_server_linux_x64_original
cp result/bin/language_server_linux_x64-fhs language_server_linux_x64
```

It raise a really strange error:

```
bwrap: Creating new namespace failed: nesting depth or /proc/sys/user/max_*_namespaces exceeded (ENOSPC)
```

Try `cat`ing the built binary, it returns:

```bash
#!/nix/store/lf0wpjrj8yx4gsmw2s3xfl58ixmqk8qa-bash-5.2-p15/bin/bash
ignored=(/nix /dev /proc /etc)
ro_mounts=()
symlinks=()
...
```

In somewhere, the code it:

```bash
cmd=(
  /nix/store/yv597q0sklzanqxckc4q1jgcs0nqsknb-bubblewrap-0.8.0/bin/bwrap
  --dev-bind /dev /dev
  --proc /proc
  --chdir "$(pwd)"
  --die-with-parent
  --ro-bind /nix /nix
  # Our glibc will look for the cache in its own path in `/nix/store`.
  # As such, we need a cache to exist there, because pressure-vessel
  # depends on the existence of an ld cache. However, adding one
  # globally proved to be a bad idea (see #100655), the solution we
  # settled on being mounting one via bwrap.
  # Also, the cache needs to go to both 32 and 64 bit glibcs, for games
  # of both architectures to work.
  --tmpfs /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc \
  --symlink /etc/ld.so.conf /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc/ld.so.conf \
  --symlink /etc/ld.so.cache /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc/ld.so.cache \
  --ro-bind /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc/rpc /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc/rpc \
  --remount-ro /nix/store/gqghjch4p1s69sv4mcjksb2kb65rwqjy-glibc-2.38-23/etc \
  --tmpfs /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc \
  --symlink /etc/ld.so.conf /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc/ld.so.conf \
  --symlink /etc/ld.so.cache /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc/ld.so.cache \
  --ro-bind /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc/rpc /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc/rpc \
  --remount-ro /nix/store/sahdf802xcjdjbx7fx8a2ap3kpr4214i-glibc-2.38-23/etc \
  "${ro_mounts[@]}"
  "${symlinks[@]}"
  "${auto_mounts[@]}"
  "${x11_args[@]}"

  /nix/store/qcs078cjly7awff60brfsvxsb0w65g8h-language_server_linux_x64-fhs-init "$@"
)
```

Which means it still is a "glorified" `PATH` concatenation before running a
binary.

It means we can repeat the steps for the original binary, but rename it at first,
and use the built binary as the original library, things work as expected:

```shell
mv language_server_linux_x64 language_server_linux_x64_original
nix-alien -r -d . language_server_linux_x64_original
nix-build default.nix
cp result/bin/language_server_linux_x64_original-fhs language_server_linux_x64

./language_server_linux_x64
# I1121 00:58:07.416549 3494061 main.go:526] Starting language server manager with pid 3494061
# I1121 00:58:07.416976 3494061 main.go:292] Language server manager attempting to connect to language server at 127.0.0.1:42100
# I1121 00:58:07.567736 3494073 main.go:520] Starting language server process with pid 3494073
# I1121 00:58:07.568233 3494073 proxy.go:93] proxyplease.proxy> No proxy provided. Attempting to infer from system.
# I1121 00:58:07.568248 3494073 proxy.go:93] proxyplease.proxy> No proxy could be determined. Assuming a direct connection.
# ...
```

