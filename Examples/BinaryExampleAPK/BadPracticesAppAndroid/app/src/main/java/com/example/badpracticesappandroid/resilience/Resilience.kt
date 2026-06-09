package com.example.badpracticesappandroid.resilience

/**
 * Familia 12: Resiliencia ausente (ResilienceAbsence / ResilienceFlag).
 * La app hace red (ver network/HttpClient.kt) pero:
 *  - NO implementa certificate pinning  -> "pinning ausente"
 *  - NO hay deteccion de root (sin RootBeer / Play Integrity / SafetyNet)
 */
object Resilience {

    // BAD: feature flag de debug encendido en runtime // CACOMI-EXPECT: ResilienceFlag
    var debugMenuEnabled = true

    // BAD: no hay deteccion de root; stub que siempre dice "no root" // CACOMI-EXPECT: ResilienceAbsence
    fun isDeviceRooted(): Boolean = false // sin RootBeer / Play Integrity / SafetyNet
}
