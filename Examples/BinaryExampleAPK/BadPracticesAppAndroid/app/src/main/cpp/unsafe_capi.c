/*
 * unsafe_capi.c
 * Equivalente Android (NDK) de ObjC/UnsafeCAPI.m — UnsafeCAPIRule.
 * APIs C inseguras compiladas dentro del .so (sobreviven al binario).
 */
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void cacomi_unsafe_capi_demo(const char *userInput) {
    char buf[16];
    // BAD: strcpy sin verificar limites // CACOMI-EXPECT: UnsafeCAPIRule
    strcpy(buf, userInput);

    char fmt[32];
    // BAD: sprintf sin limites (usar snprintf) // CACOMI-EXPECT: UnsafeCAPIRule
    sprintf(fmt, "user=%s", userInput);

    char line[64];
    // BAD: gets es inherentemente inseguro // CACOMI-EXPECT: UnsafeCAPIRule
    gets(line);

    // BAD: system() con cadena (inyeccion de comandos) // CACOMI-EXPECT: UnsafeCAPIRule
    system("ls /tmp");

    // BAD: rand() es un PRNG debil // CACOMI-EXPECT: UnsafeCAPIRule
    int r = rand();

    (void)buf; (void)fmt; (void)line; (void)r;
}
