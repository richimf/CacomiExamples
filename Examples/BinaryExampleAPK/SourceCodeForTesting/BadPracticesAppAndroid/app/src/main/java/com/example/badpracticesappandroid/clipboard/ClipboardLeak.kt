package com.example.badpracticesappandroid.clipboard

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context

/**
 * Familia: Privacidad / Almacenamiento inseguro — datos sensibles copiados al portapapeles.
 * El portapapeles en Android es accesible por otras apps (pre-Android 10 sin restriccion,
 * y apps con accesibilidad pueden leerlo en cualquier version).
 * OWASP M2 – Insecure Data Storage / M8 – Security Misconfiguration.
 */
object ClipboardLeak {

    // BAD: token de sesion copiado al portapapeles sin etiqueta sensible // CACOMI-EXPECT: InsecureStorage
    fun copySessionToken(context: Context, token: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("session_token", token) // CACOMI-EXPECT: PrivacyLeak
        clipboard.setPrimaryClip(clip)
    }

    // BAD: password copiado al portapapeles // CACOMI-EXPECT: InsecureStorage
    fun copyPassword(context: Context, password: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("password", password) // CACOMI-EXPECT: PrivacyLeak
        clipboard.setPrimaryClip(clip)
    }

    // BAD: numero de tarjeta de credito (PAN) al portapapeles // CACOMI-EXPECT: InsecureStorage
    fun copyCreditCardNumber(context: Context, pan: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("credit_card", pan) // CACOMI-EXPECT: PrivacyLeak
        clipboard.setPrimaryClip(clip)
    }

    // BAD: clave privada copiada directamente // CACOMI-EXPECT: InsecureStorage
    fun copyPrivateKey(context: Context, privateKey: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("private_key", privateKey) // CACOMI-EXPECT: PrivacyLeak
        clipboard.setPrimaryClip(clip)
    }

    // NEGATIVO: copiar un string de UI no sensible (nombre de producto) // CACOMI-EXPECT: none
    fun copyProductName(context: Context, productName: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("product_name", productName)
        clipboard.setPrimaryClip(clip)
    }

    // NEGATIVO: copiar un URL publico // CACOMI-EXPECT: none
    fun copyShareUrl(context: Context, url: String) {
        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("share_url", url)
        clipboard.setPrimaryClip(clip)
    }
}
