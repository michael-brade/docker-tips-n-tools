# Docker Debugging Tips and Tools

This repository contains tools and solutions to problems I encountered while working with docker.


## Docker Tips

When using `FROM scratch`, it is essential to copy `ld-linux` and `ld.so.cache`, unless all executables are statically
linked. Otherwise, you will get the following error message:
```
standard_init_linux.go:190: exec user process caused "no such file or directory"
```
There can be other reasons for that error message as well; for example, if there is no shell in the container but
the shell form of `ENTRYPOINT` is used, or if the shell after hash-bang doesn't exist.

Example for how to copy 64bit `ld-linux`:

```dockerfile
FROM scratch as server

# ESSENTIAL! dynamic library loader is always needed
COPY --from=build /lib64/ld-linux-x86-64.so.2  /lib64/
COPY --from=build /etc/ld.so.cache /etc/ld.so.cache

# shell is needed for ENTRYPOINT and ENV
COPY --from=build /bin/dash /bin/sh
```

`build` can be a previous stage, or a distribution such as `ubuntu:18.04`.


## Tools

* The `tools` directory contains statically linked shells (`bash`, `sash`), `strace`, and `ls`. Once
  the shell is working, the `ldd` script can display potentially missing libraries. Manually, you may
  also execute:

  ```
  /lib64/ld-linux-x86-64.so.2 --list /bin/ls
  ```

* The `cp-libs.sh` script finds out which shared libraries a given executable needs and copies them into a given folder.



