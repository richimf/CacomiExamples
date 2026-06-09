package com.example.badpracticesappandroid.jni

/**
 * Familia 1 (NEGATIVO): metodo nativo JNI. La implementacion vive en C (Java_*),
 * por lo que NO debe marcarse como no usado aunque no haya llamadas Kotlin directas.
 * CACOMI-EXPECT: none
 */
object NativeBridge {
    init {
        // El .so no se incluye en este banco de pruebas; la declaracion basta para el analisis.
        runCatching { System.loadLibrary("badpractices") }
    }

    // NEGATIVO: declaracion JNI (implementada como Java_com_example_..._nativeChecksum)
    external fun nativeChecksum(input: String): String
}
