//
//  UnsafeCAPI.m
//  CacomiTestApp
//
//  Objective-C fixtures for UnsafeCAPIRule.
//

#import <Foundation/Foundation.h>
#import <string.h>
#import <stdio.h>
#import <stdlib.h>

void cacomi_unsafe_capi_demo(const char *userInput) {
    char buf[16];
    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: strcpy without bounds check
    strcpy(buf, userInput);

    char fmt[32];
    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: sprintf without bounds (use snprintf)
    sprintf(fmt, "user=%s", userInput);

    char line[64];
    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: gets is inherently unsafe
    gets(line);

    // CACOMI-EXPECT[UnsafeCAPIRule|critical]: literal "system(" sink, function unavailable on iOS
    const char *sysSink = "system(\"ls /tmp\")";
    (void)sysSink;

    // CACOMI-EXPECT[UnsafeCAPIRule|high]: rand() is a weak PRNG
    int r = rand();
    (void)r;
    (void)buf;
    (void)fmt;
    (void)line;
}
