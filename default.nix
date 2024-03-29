{ pkgs 
}:
let
  compilers = with pkgs; {
    gcc7 = overrideCC stdenv gcc7;
    gcc8 = overrideCC stdenv gcc8;
    gcc9 = overrideCC stdenv gcc9;
    gcc10 = overrideCC stdenv gcc10;
    gcc11 = overrideCC stdenv gcc11;
    gcc12 = overrideCC stdenv gcc12;
    # clang6 = overrideCC stdenv clang_6;
    # clang7 = overrideCC stdenv clang_7;
    clang8 = overrideCC stdenv clang_8;
    clang9 = overrideCC stdenv clang_9;
    clang10 = overrideCC stdenv clang_10;
    clang12 = overrideCC stdenv clang_12;
    clang13 = overrideCC stdenv clang_13;
    clang14 = overrideCC stdenv clang_14;
    clang15 = overrideCC stdenv clang_15;
    clang16 = overrideCC stdenv clang_16;
  };

  # pass the flags as a string, comma separated
  flags_string1 = pkgs.lib.strings.splitString "," "-g,-O3,-O2,-mavx";
  # compute the power set.
  flags_string = pkgs.lib.lists.foldr (x: acc: acc ++ map (y: x + " " + y) acc ) [""] flags_string1;
  flags = builtins.listToAttrs ( map ( v: { name = v; value = v;  } ) flags_string );

  # simply pass the flags as a dict.
  org_flags = { 
    a="-g";
    b="-O2";
    c="-O3 -march=native";
  };

  originalDerivation = [ (pkgs.callPackage (import ./derivation.nix) {}) ];

  f = libname: libs: derivs: with pkgs.lib;
    concatMap (deriv:
      mapAttrsToList (libVers: lib:
        (deriv.override { "${libname}" = lib; }).overrideAttrs
          (old: { name = "${old.name}-${libVers}"; })
      ) libs
    ) derivs;

  overrides = [
    (f "stdenv" compilers)
    (f "flags" flags)
  ];
in
  pkgs.lib.foldl (a: b: a // { "${b.name}" = b; }) {} (
    pkgs.lib.foldl (a: f: f a) originalDerivation overrides
  )
