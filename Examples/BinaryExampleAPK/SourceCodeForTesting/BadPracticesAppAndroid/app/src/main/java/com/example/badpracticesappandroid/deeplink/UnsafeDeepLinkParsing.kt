package com.example.badpracticesappandroid.deeplink

import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.webkit.WebView

/**
 * Familia: Validacion de entradas / Inyeccion — parseo inseguro de deep-links e Intents.
 * Los parametros de un Intent/URI externo son controlables por el atacante; usarlos
 * directamente en SQL o WebView.loadUrl produce inyeccion (M4 / OWASP A03).
 */
object UnsafeDeepLinkParsing {

    // BAD: parametro de deep-link inyectado directamente en SQL // CACOMI-EXPECT: Injection
    fun handleDeepLinkSql(intent: Intent, db: SQLiteDatabase) {
        val uri: Uri = intent.data ?: return
        val userId = uri.getQueryParameter("user_id") // valor controlado por atacante
        // BAD: concatenacion de string en query SQL sin sanitizar // CACOMI-EXPECT: Injection
        val query = "SELECT * FROM users WHERE id = '$userId'"
        db.rawQuery(query, null)
    }

    // BAD: Uri query param pasado a WebView.loadUrl sin validacion // CACOMI-EXPECT: Injection
    fun handleDeepLinkWebView(intent: Intent, webView: WebView) {
        val uri: Uri = intent.data ?: return
        val target = uri.getQueryParameter("url") // controlado por atacante
        // BAD: URL no validada cargada en WebView (open redirect / XSS) // CACOMI-EXPECT: InputValidation
        webView.loadUrl(target ?: "about:blank")
    }

    // BAD: path segment de la URI usado en query SQL // CACOMI-EXPECT: Injection
    fun handlePathSegmentSql(intent: Intent, db: SQLiteDatabase) {
        val uri: Uri = intent.data ?: return
        val id = uri.lastPathSegment // controlado externamente
        // BAD: sin uso de parametros preparados // CACOMI-EXPECT: Injection
        db.execSQL("DELETE FROM sessions WHERE token = '$id'")
    }

    // BAD: extra del Intent usado para construir URL y cargar en WebView // CACOMI-EXPECT: InputValidation
    fun handleIntentExtraWebView(intent: Intent, webView: WebView) {
        val page = intent.getStringExtra("page") // no validado
        // BAD: podria cargar file:// o javascript: // CACOMI-EXPECT: Injection
        webView.loadUrl("https://example.com/$page")
    }

    // NEGATIVO: parametro usado con query parametrizada (no hay inyeccion) // CACOMI-EXPECT: none
    fun safeQueryWithParams(intent: Intent, db: SQLiteDatabase) {
        val uri: Uri = intent.data ?: return
        val userId = uri.getQueryParameter("user_id")
        db.rawQuery("SELECT * FROM users WHERE id = ?", arrayOf(userId))
    }

    // NEGATIVO: parametro de deeplink validado contra lista blanca antes de usar // CACOMI-EXPECT: none
    fun safeDeepLinkWebView(intent: Intent, webView: WebView) {
        val uri: Uri = intent.data ?: return
        val host = uri.host
        val allowedHosts = setOf("example.com", "www.example.com")
        if (host != null && host in allowedHosts) {
            webView.loadUrl(uri.toString())
        }
    }
}
