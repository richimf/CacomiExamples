package com.example.badpracticesappandroid.storage

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Environment
import android.os.StrictMode
import java.io.File

/**
 * Familia 9: Almacenamiento inseguro (InsecureStorage / MobileMisuse).
 */
@Suppress("DEPRECATION")
object InsecureStorage {

    // BAD: SharedPreferences world-readable/writeable // CACOMI-EXPECT: InsecureStorage
    fun worldReadablePrefs(context: Context) {
        val prefs = context.getSharedPreferences("creds", Context.MODE_WORLD_READABLE)
        // BAD: guarda password/token en claro // CACOMI-EXPECT: InsecureStorage
        prefs.edit().putString("password", "SuperSecret123!").putString("token", "abc.def.ghi").apply()

        context.getSharedPreferences("more", Context.MODE_WORLD_WRITEABLE)
            .edit().putString("api_key", "AIzaSyA-EXAMPLE").apply()
    }

    // BAD: escribe datos sensibles en almacenamiento externo // CACOMI-EXPECT: InsecureStorage
    fun writeExternal() {
        val f = File(Environment.getExternalStorageDirectory(), "secret.txt")
        f.writeText("password=SuperSecret123!")
    }

    // BAD: copia un secreto al portapapeles // CACOMI-EXPECT: InsecureStorage/MobileMisuse
    fun copyToClipboard(context: Context) {
        val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        cm.setPrimaryClip(ClipData.newPlainText("token", "Bearer eyJfakefake.token"))
    }

    // BAD: StrictMode con permitAll (desactiva detecciones) // CACOMI-EXPECT: MobileMisuse
    fun relaxStrictMode() {
        StrictMode.setThreadPolicy(StrictMode.ThreadPolicy.Builder().permitAll().build())
        StrictMode.setVmPolicy(StrictMode.VmPolicy.Builder().build())
    }
}
