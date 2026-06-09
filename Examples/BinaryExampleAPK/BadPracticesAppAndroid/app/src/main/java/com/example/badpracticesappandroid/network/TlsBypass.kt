package com.example.badpracticesappandroid.network

import java.security.cert.X509Certificate
import javax.net.ssl.HostnameVerifier
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.SSLSession
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

/**
 * Familia 8: Red / TLS (TLSTrustBypass / NetworkSecurityConfig).
 */
object TlsBypass {

    // BAD: TrustManager que confia en TODOS los certificados // CACOMI-EXPECT: TLSTrustBypass
    private val trustAll = object : X509TrustManager {
        override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
        override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {} // vacio = acepta todo
        override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
    }

    // BAD: HostnameVerifier que siempre retorna true // CACOMI-EXPECT: TLSTrustBypass
    private val allowAllHosts = HostnameVerifier { _: String?, _: SSLSession? -> true }

    fun installInsecureTls() {
        val ctx = SSLContext.getInstance("TLS")
        ctx.init(null, arrayOf<TrustManager>(trustAll), java.security.SecureRandom())
        HttpsURLConnection.setDefaultSSLSocketFactory(ctx.socketFactory)
        HttpsURLConnection.setDefaultHostnameVerifier(allowAllHosts)
    }
}
