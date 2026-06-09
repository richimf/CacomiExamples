package com.example.badpracticesappandroid.logs

import android.util.Log
import com.example.badpracticesappandroid.BuildConfig

/**
 * Familia 2: Print & Logs.
 */
object Logging {

    private const val TAG = "Auth"

    fun logAll(token: String, password: String) {
        // BAD: logs con datos sensibles // CACOMI-EXPECT: PrintAndLogs
        Log.d(TAG, "user token = $token")
        Log.v(TAG, "verbose password = $password")
        Log.i(TAG, "info session token=$token")
        Log.e(TAG, "error with password=$password")

        // BAD: println / System.out con datos sensibles // CACOMI-EXPECT: PrintAndLogs
        println("DEBUG token=$token")
        System.out.println("password=$password")

        // NEGATIVO: log envuelto en BuildConfig.DEBUG // CACOMI-EXPECT: none
        if (BuildConfig.DEBUG) {
            Log.d(TAG, "debug-only diagnostic, token redacted")
        }

        // NEGATIVO: log envuelto en isLoggable // CACOMI-EXPECT: none
        if (Log.isLoggable(TAG, Log.DEBUG)) {
            Log.d(TAG, "loggable-gated diagnostic")
        }
    }
}
