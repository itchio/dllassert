
#include <stdio.h>
#include <windows.h>

#if defined(__x86_64__)
#define DLLASSERT_ARCH "amd64"
#else
#define DLLASSERT_ARCH "i386"
#endif

/**
 * Exit with the last win32 error plus a provided message
 */
void wbail(int code, char *msg) {
  LPVOID lpvMessageBuffer;

  FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER | 
    FORMAT_MESSAGE_FROM_SYSTEM,
    NULL, GetLastError(), 
    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
    (LPWSTR)&lpvMessageBuffer, 0, NULL);

  printf("API = %s.\n", msg);
  wprintf(L"error code = %d.\n", GetLastError());
  wprintf(L"message    = %s.\n", (LPWSTR)lpvMessageBuffer);

  LocalFree(lpvMessageBuffer);

  fprintf(stderr, "%s\n", msg);
  exit(code);
}

int main (int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "Usage: %s NAME.DLL", argv[0]);
		return 1;
	}

	if (strcmp("-V", argv[1]) == 0) {
		printf("%s\n", DLLASSERT_VERSION);
		return 0;
	}

	char *dllName = argv[1];

	HMODULE module = LoadLibrary(dllName);
	if (!module) {
		wbail(127, "LoadLibrary");
	}

	printf("%s loaded successfully!\n", dllName);

	FreeLibrary(module); // ignore errors if any

	return 0;
}
