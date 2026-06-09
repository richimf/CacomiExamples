package com.example.badpracticesappandroid.logs;

import android.util.Log;

/**
 * Familia 2 en Java: Print & Logs.
 */
public class LegacyLogger {

    private static final String TAG = "LegacyAuth";

    public void dump(String token, String password) {
        // BAD: log Java con datos sensibles // CACOMI-EXPECT: PrintAndLogs
        Log.d(TAG, "java token=" + token);
        Log.e(TAG, "java password=" + password);

        // BAD: System.out en Java // CACOMI-EXPECT: PrintAndLogs
        System.out.println("java println token=" + token);

        // NEGATIVO: log detras de isLoggable // CACOMI-EXPECT: none
        if (Log.isLoggable(TAG, Log.DEBUG)) {
            Log.d(TAG, "gated");
        }
    }
}
