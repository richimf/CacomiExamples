package com.example.badpracticesappandroid.network

import okhttp3.OkHttpClient
import okhttp3.Request

/**
 * Familia 8 + 12: OkHttp sin CertificatePinner (pinning ausente).
 * CACOMI-EXPECT: ResilienceAbsence / TLSTrustBypass
 */
object HttpClient {

    // BAD: cliente OkHttp SIN CertificatePinner // CACOMI-EXPECT: ResilienceAbsence
    private val client = OkHttpClient.Builder().build()

    fun fetch(): Request {
        // BAD: endpoint cleartext http://
        return Request.Builder().url("http://api.example.com/data").build()
    }

    fun client(): OkHttpClient = client
}
