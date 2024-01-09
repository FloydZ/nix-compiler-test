Nix Compiler Test:
=================

This small repository shows how to build a (currently only C) program, with 
different compilers and different compiler flags.

Run it with:
```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
```
this will build `main.c` via the `builder.sh` script. 
