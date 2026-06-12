//
// unsafe_buffers.cpp
// Equivalente Android (NDK) de Cpp/UnsafeBuffers.cpp — UnsafeCAPIRule + UnusedCode (C++).
//
#include <cstring>
#include <cstdio>
#include <cstdlib>

extern "C" void cacomi_unsafe_buffers(const char *userInput) {
    char buf[16];
    // BAD: strcpy sin verificar limites (C++) // CACOMI-EXPECT: UnsafeCAPIRule
    strcpy(buf, userInput);

    char fmt[32];
    // BAD: sprintf sin limites (C++) // CACOMI-EXPECT: UnsafeCAPIRule
    sprintf(fmt, "user=%s", userInput);

    char dst[8];
    // BAD: memcpy con longitud controlada por el atacante // CACOMI-EXPECT: UnsafeCAPIRule
    memcpy(dst, userInput, strlen(userInput));

    // BAD: system() (inyeccion de comandos) // CACOMI-EXPECT: UnsafeCAPIRule
    system("ls /tmp");

    (void)buf; (void)fmt; (void)dst;
}

// BAD: funcion C++ no usada // CACOMI-EXPECT: UnusedCode
static int unused_cpp_helper(int a, int b) {
    return a * b + 42;
}

// BAD: variable global C++ no usada // CACOMI-EXPECT: UnusedCode
static const char *kUnusedCppConstant = "dead-cpp-symbol";
