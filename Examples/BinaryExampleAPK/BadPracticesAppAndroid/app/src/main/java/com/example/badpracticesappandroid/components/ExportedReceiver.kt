package com.example.badpracticesappandroid.components

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

// BAD: Receiver exportado sin permiso, con intent-filter // CACOMI-EXPECT: AndroidComponentMisuse
class ExportedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        // BAD: confia en datos de un broadcast recibido de cualquier app
        val command = intent?.getStringExtra("cmd")
        Log.i("ExportedReceiver", "received cmd=$command")
    }
}
