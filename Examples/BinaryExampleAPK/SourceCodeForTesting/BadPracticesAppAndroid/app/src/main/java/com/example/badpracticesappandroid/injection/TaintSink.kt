package com.example.badpracticesappandroid.injection

import android.content.Context
import android.webkit.WebView
import java.io.File

/**
 * Familia 6: SINK del flujo de taint cross-file.
 * La FUENTE esta en components/DeepLinkActivity.kt (getStringExtra / intent.data),
 * y fluye hasta aqui SIN sanitizar -> SQL, WebView.loadUrl y ruta de archivo.
 * CACOMI-EXPECT: InjectionRules/Taint
 */
object TaintSink {

    fun runUnsanitized(context: Context, userId: String, targetUrl: String) {
        // BAD/TAINT-SINK 1: input fluye a SQL sin sanitizar
        val db = context.openOrCreateDatabase("app.db", Context.MODE_PRIVATE, null)
        db.execSQL("INSERT INTO sessions(uid) VALUES('" + userId + "')")

        // BAD/TAINT-SINK 2: input fluye a WebView.loadUrl sin validar
        val webView = WebView(context)
        webView.loadUrl(targetUrl)

        // BAD/TAINT-SINK 3: input fluye a una ruta de archivo (path traversal)
        val f = File(context.filesDir, userId)
        f.writeText("data")
    }

    // NEGATIVO: el valor es una constante (sin fuente), el sink NO debe marcarse tainted
    // CACOMI-EXPECT: none
    fun runSafe(context: Context) {
        val constant = "static-greeting"
        val db = context.openOrCreateDatabase("app.db", Context.MODE_PRIVATE, null)
        db.execSQL("INSERT INTO sessions(uid) VALUES('$constant')")
    }
}
