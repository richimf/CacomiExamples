package com.example.badpracticesappandroid.logs

import android.util.Log

/**
 * Familia logs (P1): logs sensibles que sobreviven por estar envueltos en una
 * condicion de runtime (no en el inicio de linea). Paridad con
 * ValidationFixtures conditional-wrapped logs.
 *
 * TODOS los valores son DUMMY / de ejemplo.
 */
object ConditionalLogging {

    private const val TAG = "Auth"

    // BAD: password logueado dentro de un if de runtime // CACOMI-EXPECT: PrintAndLogs
    fun logIfFlag(password: String, debugFlag: Boolean) {
        if (debugFlag) {
            Log.e(TAG, "password=$password")
        }
    }

    // BAD: token logueado dentro de una expresion when // CACOMI-EXPECT: PrintAndLogs
    fun logWhen(token: String, level: Int) {
        when (level) {
            2 -> Log.d(TAG, "auth token = $token")
            else -> Log.v(TAG, "verbose token = $token")
        }
    }

    // BAD: api key impresa a System.out tras un guard // CACOMI-EXPECT: PrintAndLogs
    fun logAfterGuard(apiKey: String, enabled: Boolean) {
        if (!enabled) return
        println("api key: $apiKey")
    }

    // BAD: numero de tarjeta completo en el log // CACOMI-EXPECT: PrintAndLogs
    fun logCard(pan: String) {
        Log.i(TAG, "charging card $pan")
    }

    // NEGATIVO: protegido por BuildConfig.DEBUG (no llega a release) // CACOMI-EXPECT: none
    fun safeLog(token: String) {
        if (com.example.badpracticesappandroid.BuildConfig.DEBUG) {
            Log.d(TAG, "token=$token")
        }
    }

    // NEGATIVO: dato no sensible (sin identificador secreto) // CACOMI-EXPECT: none
    fun countLog(count: Int) {
        Log.d(TAG, "loaded $count rows")
    }
}
