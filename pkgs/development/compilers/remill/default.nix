{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages_13,
  glog,
  gflags,
  git,
  gtest,
  libxml2,
  xed
}:
let
  llvmPackages = llvmPackages_13;
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
