#!/bin/sh -xe

7za | head -2
gcc -v
cppcheck --error-exitcode=1 src

export DLLASSERT_VERSION=head
if [ -n "$CI_BUILD_TAG" ]; then
  export DLLASSERT_VERSION=$CI_BUILD_TAG
fi
export CI_VERSION=$CI_BUILD_REF_NAME
export DLLASSERT_CFLAGS="-DDLLASSERT_VERSION=\\\"$DLLASSERT_VERSION\\\""

make
file dllassert32.exe
file dllassert64.exe

export CI_OS="windows"

# sign (win)
if [ "$CI_OS" = "windows" ]; then
  WIN_SIGN_KEY="itch corp."
  WIN_SIGN_URL="http://timestamp.comodoca.com/?td=sha256"

  signtool.exe sign //v //s MY //n "$WIN_SIGN_KEY" //fd sha256 //tr "$WIN_SIGN_URL" //td sha256 dllassert32.exe
  signtool.exe sign //v //s MY //n "$WIN_SIGN_KEY" //fd sha256 //tr "$WIN_SIGN_URL" //td sha256 dllassert64.exe
fi

# verify
mkdir dllassert
mv dllassert32.exe dllassert
mv dllassert64.exe dllassert
7za a dllassert.7z dllassert

# set up a file hierarchy that ibrew can consume, ie:
#
# - dl.itch.ovh
#   - dllassert
#     - windows-amd64
#       - LATEST
#       - v0.3.0
#         - dllassert.7z
#         - dllassert
#           - dllassert32.exe
#           - dllassert64.exe
#         - SHA1SUMS

for CI_ARCH in i386 amd64; do
    BINARIES_DIR="binaries/$CI_OS-$CI_ARCH"
    mkdir -p $BINARIES_DIR/$CI_VERSION
    cp dllassert.7z $BINARIES_DIR/$CI_VERSION
    cp -rf dllassert $BINARIES_DIR/$CI_VERSION

    (cd $BINARIES_DIR/$CI_VERSION && sha1sum *.7z > SHA1SUMS && sha256sum *.7z > SHA256SUMS)

    if [ -n "$CI_BUILD_TAG" ]; then
    echo $CI_BUILD_TAG > $BINARIES_DIR/LATEST
    fi
done
