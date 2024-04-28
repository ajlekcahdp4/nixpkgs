{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages_14,
  glog,
  gflags,
  git,
  gtest,
  libffi,
  libxml2,
  xed,
  fetchgit,
  ghidra,
  zlib
}:
let
  llvmPackages = llvmPackages_14;
  ghidraSource = fetchgit {
    url = "https://github.com/NationalSecurityAgency/ghidra";
    sha256 = "sha256-3pJXwZW1ltvA31vy3Occbnvdy8ksXrFf0NLksUvgdQk=";
#    owner = "NationalSecurityAgency";
#    repo = "ghidra";
#    rev = "v10.2.3";
  };
  sleigh = stdenv.mkDerivation rec {
    pname = "sleigh";
    version = "7c6b742";

    src = fetchFromGitHub {
      owner = "lifting-bits";
      repo = "sleigh";
      rev = "7c6b742";
      sha256 = "sha256-3ThTyx8fWhQh/gFbsk3Omls8+GOpBFgmVyyIiBmh9Rs=";
    };

    patches = [
      ./sleigh-no-fetch-content.patch
    ];

    buildInputs = [
      cmake
      git
      ghidra
      zlib
    ];

    cmakeFlags = [
      "-DGHIDRA_INSTALL_DIR=${ghidraSource}"
    ];
  };
in stdenv.mkDerivation rec {
  pname = "remill";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "lifting-bits";
    repo = "remill";
    rev = "v${version}";
    sha256 = "sha256-9cCWEM4r/4DeygNbZkXHqHreOYSjUpKUrUScIegvwAw=";
  };

  nativeBuildInputs = [
    cmake
    git
    gtest
  ];

  patches = [
    ./cmake_no_fetch_sleigh.patch
    ./use_system_xed.patch
    ./cmake_do_not_install_3rd_party_libs.patch
  ];

  buildInputs = [
    llvmPackages.llvm.dev
    llvmPackages.libclang
    xed
    glog
    gflags
    libxml2
    libffi
    sleigh
 ];

  cmakeFlags = [
    "-DUSE_SYSTEM_DEPENDENCIES=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/lifting-bits/remill";
    description = "Library for lifting machine code to LLVM bitcode";
    license = licenses.mit;
  };
}
