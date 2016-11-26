#!/bin/sh -xe

7za | head -2
gcc -v
cppcheck --error-exitcode=1 src

export DLLASSERT_VERSION=head
if [ -n "$CI_BUILD_TAG" ]; then
  export DLLASSERT_VERSIOn=$CI_BUILD_TAG
fi
export DLLASSERT_CFLAGS="-DDLLASSERT_VERSION=\\\"$DLLASSERT_VERSION\\\""

make
file dllassert32.exe
file dllassert64.exe