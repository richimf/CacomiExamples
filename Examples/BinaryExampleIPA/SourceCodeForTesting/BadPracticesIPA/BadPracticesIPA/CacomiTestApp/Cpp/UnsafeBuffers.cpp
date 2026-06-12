//
//  UnsafeBuffers.cpp
//  CacomiTestApp
//
//  C++ fixtures for UnsafeCAPIRule.
//

#include <cstring>
#include <cstdio>
#include <cstdlib>

extern "C" void cacomi_unsafe_buffers(const char *userInput) {
    char buf[16];
    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: strcpy without bounds check (C++)
    strcpy(buf, userInput);

    char fmt[32];
    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: sprintf without bounds (C++)
    sprintf(fmt, "user=%s", userInput);

    char dst[8];
    // CACOMI-EXPECT[UnsafeCAPIRule|high]: memcpy with attacker-controlled length
    memcpy(dst, userInput, strlen(userInput));

    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: literal "system(" sink, function unavailable on iOS
    const char *sysSink = "system(\"ls /tmp\")";
    (void)sysSink;

    (void)buf;
    (void)fmt;
    (void)dst;
}
