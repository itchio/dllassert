# dllassert

![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)

Command-line tool to assert that a library loads correctly on Windows.

### Usage

The Makefile produces two executables, `assertdll32.exe` and `assertdll64.exe`, which
can be used to test for 32-bit and 64-bit DLLs, respectively.

```
assertdll32.exe msvcp100.dll
```

...will return 0 if the DLL was loaded successfully, or 1 and an error message if not.

### License

dllassert is released under the MIT license, see `LICENSE.txt` for details
