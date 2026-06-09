package com.example.badpracticesappandroid.components

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

/**
 * Malos usos de componentes/IPC en codigo (no solo manifest).
 * CACOMI-EXPECT: AndroidComponentMisuse
 */
object ComponentMisuse {

    // BAD: PendingIntent con FLAG_MUTABLE (mutable) // CACOMI-EXPECT: AndroidComponentMisuse
    fun mutablePendingIntent(context: Context): PendingIntent {
        val intent = Intent("com.example.ACTION")
        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_MUTABLE)
    }

    // BAD: PendingIntent con flags = 0 (implicitamente mutable en APIs viejas)
    fun zeroFlagPendingIntent(context: Context): PendingIntent {
        val intent = Intent("com.example.ACTION")
        return PendingIntent.getActivity(context, 0, intent, 0)
    }

    // BAD: registerReceiver con RECEIVER_EXPORTED (expone a otras apps)
    fun registerExported(context: Context) {
        context.registerReceiver(ExportedReceiver(), IntentFilter("com.example.ACTION"), Context.RECEIVER_EXPORTED)
    }

    // BAD: broadcast sin permiso (cualquier app puede recibirlo)
    fun broadcastInsecure(context: Context) {
        context.sendBroadcast(Intent("com.example.ACTION").putExtra("token", "secret-token-123"))
    }
}
