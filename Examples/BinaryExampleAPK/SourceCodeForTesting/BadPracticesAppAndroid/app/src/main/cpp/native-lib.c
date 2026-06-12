/*
 * native-lib.c
 * Implementa el metodo JNI declarado en jni/NativeBridge.kt (external fun nativeChecksum).
 * Usa intencionalmente APIs inseguras. // CACOMI-EXPECT: UnsafeCAPIRule
 */
#include <jni.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

// declaradas en unsafe_capi.c / unsafe_buffers.cpp
extern void cacomi_unsafe_capi_demo(const char *userInput);
#ifdef __cplusplus
extern "C" {
#endif
void cacomi_unsafe_buffers(const char *userInput);
#ifdef __cplusplus
}
#endif

JNIEXPORT jstring JNICALL
Java_com_example_badpracticesappandroid_jni_NativeBridge_nativeChecksum(
        JNIEnv *env, jobject thiz, jstring input) {
    const char *in = (*env)->GetStringUTFChars(env, input, NULL);

    // BAD: copia sin limites a buffer fijo // CACOMI-EXPECT: UnsafeCAPIRule
    char buf[16];
    strcpy(buf, in);

    char out[64];
    // BAD: sprintf sin limites // CACOMI-EXPECT: UnsafeCAPIRule
    sprintf(out, "chk-%d", rand());

    cacomi_unsafe_capi_demo(in);
    cacomi_unsafe_buffers(in);

    (*env)->ReleaseStringUTFChars(env, input, in);
    return (*env)->NewStringUTF(env, out);
}
