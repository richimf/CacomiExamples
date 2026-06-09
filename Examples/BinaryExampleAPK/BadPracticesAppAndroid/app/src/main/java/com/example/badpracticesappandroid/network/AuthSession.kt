package com.example.badpracticesappandroid.network

import android.webkit.CookieManager
import java.net.HttpCookie

/**
 * Equivalente Android de AuthSession.swift — AuthSessionRule.
 */
object AuthSession {

    // BAD: la sesion nunca expira // CACOMI-EXPECT: AuthSessionRule
    const val SESSION_EXPIRY_MILLIS: Long = Long.MAX_VALUE

    // BAD: bearer token en query param de la URL (se filtra en logs/proxies) // CACOMI-EXPECT: AuthSessionRule
    fun loginUrl(token: String): String =
        "https://api.fake-cacomi.com/session?token=$token"

    // BAD: cookie de sesion sin flags HttpOnly/Secure // CACOMI-EXPECT: AuthSessionRule
    fun persistSessionCookie(value: String) {
        val cookie = HttpCookie("SESSIONID", value).apply {
            domain = "fake-cacomi.com"
            path = "/"
            // sin secure, sin httpOnly
        }
        CookieManager.getInstance().setCookie("https://fake-cacomi.com", cookie.toString())
    }

    // NEGATIVO: token en header Authorization + timeout/expiry definido // CACOMI-EXPECT: none
    fun secureRequestHeaders(token: String): Map<String, String> = mapOf(
        "Authorization" to "Bearer $token"
    )
}
