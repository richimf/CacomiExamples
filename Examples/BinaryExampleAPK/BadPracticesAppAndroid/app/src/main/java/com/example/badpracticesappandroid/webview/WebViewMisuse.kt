package com.example.badpracticesappandroid.webview

import android.annotation.SuppressLint
import android.content.Context
import android.webkit.JavascriptInterface
import android.webkit.WebView

/**
 * Familia 7: WebView (WebViewMisuse).
 */
@SuppressLint("SetJavaScriptEnabled")
object WebViewMisuse {

    fun configure(context: Context, userInput: String): WebView {
        val web = WebView(context)
        // BAD: JavaScript habilitado // CACOMI-EXPECT: WebViewMisuse
        web.settings.javaScriptEnabled = true
        // BAD: acceso a ficheros locales // CACOMI-EXPECT: WebViewMisuse
        web.settings.allowFileAccess = true
        web.settings.allowFileAccessFromFileURLs = true
        web.settings.allowUniversalAccessFromFileURLs = true

        // BAD: bridge JS->Java expuesto // CACOMI-EXPECT: WebViewMisuse
        web.addJavascriptInterface(JsBridge(), "AndroidBridge")

        // BAD: carga por cleartext http:// // CACOMI-EXPECT: WebViewMisuse
        web.loadUrl("http://example.com/login")

        // BAD: evaluateJavascript con input no confiable // CACOMI-EXPECT: WebViewMisuse
        web.evaluateJavascript("doSearch('" + userInput + "')", null)
        return web
    }

    class JsBridge {
        @JavascriptInterface
        fun getToken(): String = "exposed-token"
    }
}
