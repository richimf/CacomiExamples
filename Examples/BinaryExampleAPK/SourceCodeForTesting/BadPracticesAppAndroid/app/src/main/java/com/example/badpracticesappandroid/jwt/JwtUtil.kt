package com.example.badpracticesappandroid.jwt

/**
 * Familia 5: JWT (JWTWeakSecret / JWTValidation).
 * Implementacion casera intencionalmente insegura. Valores DUMMY.
 */
object JwtUtil {

    // BAD: secreto de firma JWT hardcodeado y debil // CACOMI-EXPECT: JWTWeakSecret
    private const val JWT_SECRET = "changeme"

    // BAD: validacion no constant-time (==) + acepta alg "none" // CACOMI-EXPECT: JWTValidation
    fun verify(token: String, expectedSignature: String): Boolean {
        val parts = token.split(".")
        val header = parts.getOrElse(0) { "" }

        // BAD: acepta algoritmo "none" (sin firma)
        if (header.contains("\"alg\":\"none\"") || header.contains("none")) {
            return true
        }

        val signature = parts.getOrElse(2) { "" }
        // BAD: comparacion de firma con == (vulnerable a timing attacks)
        return signature == expectedSignature
    }

    fun sign(payload: String): String {
        // BAD: "firma" basada en secreto debil hardcodeado
        return "$payload.$JWT_SECRET"
    }
}
