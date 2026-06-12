package com.example.badpracticesappandroid.components

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

// BAD: Service exportado sin permiso (declarado exported=true en el manifest)
// CACOMI-EXPECT: AndroidComponentMisuse
class ExportedService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i("ExportedService", "started")
        return START_NOT_STICKY
    }
}

// NEGATIVO: Service interno no exportado // CACOMI-EXPECT: none
class SafeInternalService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
}

// BAD: Service exportado con intent-filter y sin permiso declarado en el manifest
// CACOMI-EXPECT: ExportedComponent
class ExportedServiceWithFilter : Service() {
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i("ExportedServiceFilter", "started via intent-filter, sin permiso requerido")
        return START_NOT_STICKY
    }
}
