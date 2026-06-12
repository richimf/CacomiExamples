package com.example.badpracticesappandroid.platform

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.webkit.WebView
import dalvik.system.DexClassLoader
import java.io.ByteArrayInputStream
import java.io.File
import java.io.ObjectInputStream

/**
 * Equivalente Android de DangerousAPIs.swift / AntiTampering.swift — UnsafePlatformAPIRule.
 * Deserializacion insegura, path traversal, carga dinamica de codigo, reflexion sobre
 * input no confiable, apertura de URLs sin validar y flags inseguros.
 */
object DangerousApis {

    // BAD: deserializacion insegura (Java) -> gadget chains / RCE // CACOMI-EXPECT: UnsafePlatformAPIRule
    fun insecureDeserialize(data: ByteArray): Any? {
        ObjectInputStream(ByteArrayInputStream(data)).use { return it.readObject() }
    }

    // BAD: path traversal, sin canonicalizar ("../../etc/passwd") // CACOMI-EXPECT: UnsafePlatformAPIRule
    fun readUserSuppliedFile(context: Context, relative: String): String {
        val f = File(context.filesDir, relative)
        return f.readText()
    }

    // BAD: carga dinamica de codigo desde ruta externa // CACOMI-EXPECT: UnsafePlatformAPIRule
    fun loadDynamicDex(context: Context, dexPath: String): Class<*> {
        val loader = DexClassLoader(dexPath, context.cacheDir.absolutePath, null, javaClass.classLoader)
        return loader.loadClass("com.attacker.Payload")
    }

    // BAD: reflexion con nombre de metodo no confiable // CACOMI-EXPECT: UnsafePlatformAPIRule
    fun invokeArbitrary(target: Any, methodName: String): Any? {
        val m = target.javaClass.getMethod(methodName)
        return m.invoke(target)
    }

    // BAD: abre cualquier URL/Intent sin validar esquema ni host // CACOMI-EXPECT: UnsafePlatformAPIRule
    fun openAnyUrl(context: Context, raw: String) {
        context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(raw)))
    }

    // BAD: WebView debugging habilitado en produccion // CACOMI-EXPECT: UnsafePlatformAPIRule/ResilienceFlag
    fun enableWebDebug() {
        WebView.setWebContentsDebuggingEnabled(true)
    }

    // BAD: deteccion de root stub que siempre dice "no root" // CACOMI-EXPECT: ResilienceFlagRule
    fun isDeviceRooted(): Boolean = false

    // BAD: flags inseguros tipo config // CACOMI-EXPECT: ResilienceFlagRule
    const val DEBUG_MENU_ENABLED = true
    const val ALLOW_SELF_SIGNED_CERTS = true
    const val SKIP_CERT_PINNING = true
    const val SSL_VERIFY_HOST = false
    const val SSL_VERIFY_PEER = false
    const val TLS_INSECURE_SKIP_VERIFY = true

    // BAD: secretos dummy que matchean regex comunes de scanners // CACOMI-EXPECT: SecretPattern
    const val AWS_LOOKS_LIKE = "AKIAJSIE27KKMHXI3BJQ"
    const val GOOGLE_LOOKS_LIKE = "AIzaSyDuLooksLikeRealGoogleKeyOnlyForScanner"
    const val SLACK_LOOKS_LIKE = "xoxp-1234567890-1234567890-1234567890-abcdefghijklmnop"
    const val JWT_LOOKS_LIKE = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NSJ9.FAKE_SIGNATURE_CACOMI"
    const val GITHUB_FINE_GRAINED = "github_pat_FAKECACOMI11AAAAAAAAA0_FAKECACOMIfinegrainedTokenABCDEFGHIJKLMNOPQRSTUVWX1234"
    const val SQUARE_ACCESS_TOKEN = "sq0atp-FAKECACOMIsquareAccessToken123"
    const val DISCORD_BOT_TOKEN = "FAKECACOMIdiscordBotTokenMTAxMjM0NTY3ODkw.FAKE.XXXXXXXXXXXXXXXXXXXXXXXXXXX"
    const val NPM_TOKEN = "npm_FAKECACOMInpmTokenABCDEFGHIJ1234567890abcdef"
}
