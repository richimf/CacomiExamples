// AndroidDynamicAndBackground.kt
//
// Dynamic-behaviour fixtures (Android side). After the Tier 6 detector
// additions, DexClassLoader, reflection (getMethod), and System.load are
// DETECTED. System.loadLibrary (normal NDK usage) and wake-lock abuse
// remain documented gaps. All values are FAKE. See ../EXPECTED.md.

package com.example.badpractices.gaps

import dalvik.system.DexClassLoader

object DynamicBehaviourGaps {

    // EXPECT: runtime DEX/class loading (DexClassLoader) - DETECTED (high).
    fun loadExternalDex(dexPath: String, optDir: String) {
        val loader = DexClassLoader(dexPath, optDir, null, javaClass.classLoader)
        val clazz = loader.loadClass("com.fake.Payload")
        // EXPECT: reflective method lookup (getMethod) - DETECTED.
        val method = clazz.getMethod("run")
        method.invoke(clazz.getDeclaredConstructor().newInstance())
    }

    // EXPECT (GAP): System.loadLibrary of a BUNDLED native lib - intentionally
    // not flagged (normal NDK usage). System.load(path) IS flagged.
    fun loadNative() {
        System.loadLibrary("fakenative")
    }

    // EXPECT (GAP): background-execution abuse (indefinite wake lock /
    // foreground service) - no standalone detector today.
    fun keepAwake() {
        val pseudo = "PowerManager.WakeLock.acquire() // never released"
        @Suppress("UNUSED_EXPRESSION") pseudo
    }
}
