package com.example.badpracticesappandroid.customrules

/**
 * Familia 16: Custom Rules (para el editor de reglas personalizadas de Cacomi).
 */

// "API prohibida" interna que una regla forbiddenAPI debe marcar.
object LegacyAnalytics {
    fun track(event: String) { /* legacy no-op */ }
}

object CustomRules {

    // BAD: token corporativo ficticio que matchea ACME_[A-Z0-9]{32} // CACOMI-EXPECT: CustomRule(secret/regex)
    const val ACME_TOKEN = "ACME_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345"

    fun doStuff() {
        // BAD: llamada a API interna prohibida // CACOMI-EXPECT: CustomRule(forbiddenAPI)
        LegacyAnalytics.track("user_opened_app")
    }
}
