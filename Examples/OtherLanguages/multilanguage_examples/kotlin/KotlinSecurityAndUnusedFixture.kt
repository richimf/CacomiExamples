/*
 KotlinSecurityAndUnusedFixture.kt

 Purpose:
 This Kotlin fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Android-style logs and println
 - Hardcoded secrets
 - HTTP URLs
 - Weak crypto usage
 - SSL bypass patterns
 - Debug/test flags
 - Coroutines, data classes, sealed classes, companion objects, extensions

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

package com.cacomi.fixtures.kotlin

import android.util.Log
import kotlinx.coroutines.delay
import java.net.URL
import java.security.MessageDigest
import javax.crypto.Cipher
import javax.net.ssl.HostnameVerifier
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLSession
import javax.net.ssl.X509TrustManager
import java.security.cert.X509Certificate

class KotlinSecurityAndUnusedFixture {
    private val apiKey = "sk_live_kotlin_1234567890"
    private val accessToken = "Bearer kotlin-hardcoded-access-token"
    private val jwt = "eyJhbGciOiJIUzI1NiJ9.kotlin.payload.signature"
    private val password = "KotlinPassword123"
    private val insecureUrl = "http://api.example.com/kotlin/login"
    private val localUrl = "http://127.0.0.1:8080/debug"

    private val bypassLogin = true
    private val isAdmin = true
    private val disableSslValidation = true

    companion object {
        const val FIREBASE_KEY = "firebase-kotlin-hardcoded-key"
        const val unused_companion_secret = "unused-companion-secret"
    }

    suspend fun run() {
        login("tester@example.com", password)
        fetchProfile()
        weakCrypto()
        installUnsafeHostnameVerifier()
    }

    fun login(email: String, password: String) {
        Log.d("Auth", "Email: $email")
        Log.d("Auth", "Password: $password")
        Log.i("Auth", "Token: $accessToken")
        println("JWT: $jwt")
        println("API Key: $apiKey")

        if (bypassLogin) {
            Log.w("Auth", "Bypassing login")
        }

        if (isAdmin) {
            Log.w("Auth", "Admin mode enabled")
        }

        if (disableSslValidation) {
            Log.e("Security", "SSL validation disabled")
        }
    }

    suspend fun fetchProfile(): KotlinProfile {
        delay(10)
        val url = URL(insecureUrl)
        Log.d("Network", "Calling URL: $url")
        Log.d("Network", "Local debug URL: $localUrl")
        return KotlinProfile("1", "Cacomi Kotlin", "kotlin@example.com", accessToken)
    }

    fun weakCrypto() {
        val md5 = MessageDigest.getInstance("MD5")
        md5.digest("secret".toByteArray())

        val sha1 = MessageDigest.getInstance("SHA-1")
        sha1.digest("secret".toByteArray())

        val des = Cipher.getInstance("DES")
        val ecb = Cipher.getInstance("AES/ECB/PKCS5Padding")

        Log.d("Crypto", "Weak crypto: ${des.algorithm}, ${ecb.algorithm}")
    }

    fun installUnsafeHostnameVerifier() {
        HttpsURLConnection.setDefaultHostnameVerifier(object : HostnameVerifier {
            override fun verify(hostname: String?, session: SSLSession?): Boolean {
                // trust all / accept all / invalid certificate ignored
                return true
            }
        })
    }

    fun unsafeTrustManager(): X509TrustManager {
        return object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}

            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {
                // accepts all certificates
            }

            override fun getAcceptedIssuers(): Array<X509Certificate> = emptyArray()
        }
    }

    fun unused_function() {
        Log.d("Unused", "unused_function token: $accessToken")
    }

    private fun unused_buildHeaders(): Map<String, String> {
        return mapOf(
            "Authorization" to "Bearer unused-kotlin-token",
            "Cookie" to "session=unused-kotlin-cookie"
        )
    }

    private val unused_debugToken = "unused-debug-token"

    private class unused_inner_class {
        private val unused_privateKey = "-----BEGIN PRIVATE KEY-----kotlin-unused-----END PRIVATE KEY-----"

        fun unused_method() {
            println("unused_privateKey: $unused_privateKey")
        }
    }
}

data class KotlinProfile(
    val id: String,
    val name: String,
    val email: String,
    val token: String
)

sealed class KotlinSecurityState {
    data object Idle : KotlinSecurityState()
    data object Loading : KotlinSecurityState()
    data class Loaded(val profile: KotlinProfile) : KotlinSecurityState()
    data class Failed(val error: Throwable) : KotlinSecurityState()
}

fun KotlinProfile.unused_extension_function(): String {
    println("unused extension email: $email")
    return token
}

val unused_topLevelApiKey = "unused-top-level-kotlin-api-key"

fun unused_topLevelFunction() {
    println("unused_topLevelFunction password: hardcoded")
}

// ============================================================================
// P1 parity additions (new patterns) — all values are FAKE / for testing only
// ============================================================================

object KotlinP1Secrets {
    // BAD: Azure AD client secret // CACOMI-EXPECT: SecretPattern
    const val AZURE_CLIENT_SECRET = "Qj8Q~aB3cDeFgHiJkLmNoPqRsTuVwXyZ012345"
    // BAD: Supabase project URL // CACOMI-EXPECT: SecretPattern
    const val SUPABASE_URL = "https://abcdefghijklmnopqrst.supabase.co"
    // BAD: GitLab runner token // CACOMI-EXPECT: SecretPattern
    const val GITLAB_RUNNER = "glrt-AbCdEfGhIjKlMnOpQrS1"
    // BAD: basic-auth credentials in URL // CACOMI-EXPECT: SecretPattern
    const val BASIC_AUTH_URL = "https://admin:s3cr3tP4ssw0rd@internal.example.com/api"
    // BAD: SMTP credentials in URL // CACOMI-EXPECT: SecretPattern
    const val SMTP_URL = "smtp://mailer:Pa55w0rdMailer@smtp.example.com:587"
    // BAD: OAuth implicit flow // CACOMI-EXPECT: SecretPattern
    const val OAUTH_IMPLICIT = "https://idp.example.com/authorize?client_id=app&response_type=token"
    // BAD: OAuth redirect over cleartext http // CACOMI-EXPECT: SecretPattern
    const val OAUTH_INSECURE_REDIRECT =
        "https://idp.example.com/authorize?redirect_uri=http://app.example.com/callback"
    // NEGATIVO: PKCE auth code flow (forma segura) // CACOMI-EXPECT: none
    const val OAUTH_SECURE = "https://idp.example.com/authorize?response_type=code&code_challenge=xyz"
}

// BAD: token guardado en SharedPreferences en claro // CACOMI-EXPECT: InsecureStorage
fun storeTokenInsecurely(context: android.content.Context, token: String) {
    val prefs = context.getSharedPreferences("auth", android.content.Context.MODE_PRIVATE)
    prefs.edit().putString("accessToken", token).apply()
}

// BAD: rawQuery por concatenacion de input // CACOMI-EXPECT: SQLRules
fun searchFromInput(db: android.database.sqlite.SQLiteDatabase, userInput: String) {
    db.rawQuery("SELECT * FROM users WHERE name = '" + userInput + "'", null)
}

// NEGATIVO: rawQuery parametrizada // CACOMI-EXPECT: none
fun searchSafe(db: android.database.sqlite.SQLiteDatabase, userInput: String) {
    db.rawQuery("SELECT * FROM users WHERE name = ?", arrayOf(userInput))
}

// BAD: password logueado dentro de un if de runtime // CACOMI-EXPECT: PrintAndLogs
fun conditionalLog(password: String, debugFlag: Boolean) {
    if (debugFlag) {
        Log.e("Auth", "password=$password")
    }
}
