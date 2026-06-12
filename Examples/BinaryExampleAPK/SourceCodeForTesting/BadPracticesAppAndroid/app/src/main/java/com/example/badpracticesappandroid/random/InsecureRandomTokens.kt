package com.example.badpracticesappandroid.random

import java.security.SecureRandom
import java.util.Random
import kotlin.math.abs

/**
 * Familia: Criptografia debil / Aleatoriedad insegura — tokens y OTPs generados con
 * java.util.Random o Math.random() (no criptograficos, predecibles).
 * OWASP M10 – Insufficient Cryptography / CWE-330.
 */
object InsecureRandomTokens {

    // BAD: token de sesion generado con java.util.Random (predecible) // CACOMI-EXPECT: InsecureRandom
    fun generateSessionTokenWeak(): String {
        val rnd = Random() // CACOMI-EXPECT: InsecureRandom
        val sb = StringBuilder()
        repeat(32) { sb.append(rnd.nextInt(16).toString(16)) }
        return sb.toString()
    }

    // BAD: OTP de 6 digitos con java.util.Random // CACOMI-EXPECT: InsecureRandom
    fun generateOtpWeak(): String {
        val rnd = Random() // CACOMI-EXPECT: InsecureRandom
        return (rnd.nextInt(900000) + 100000).toString()
    }

    // BAD: Math.random() para generar nonce (predecible, basado en System time) // CACOMI-EXPECT: WeakCrypto
    fun generateNonceWeak(): String {
        val value = (Math.random() * Long.MAX_VALUE).toLong() // CACOMI-EXPECT: InsecureRandom
        return value.toString(16)
    }

    // BAD: semilla fija en Random (completamente predecible) // CACOMI-EXPECT: InsecureRandom
    fun generateTokenWithSeed(): String {
        val rnd = Random(42L) // semilla fija // CACOMI-EXPECT: InsecureRandom
        return abs(rnd.nextLong()).toString(16)
    }

    // BAD: token de reset de password con java.util.Random // CACOMI-EXPECT: InsecureRandom
    fun generatePasswordResetToken(): String {
        val chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        val rnd = Random() // CACOMI-EXPECT: InsecureRandom
        return (1..24).map { chars[rnd.nextInt(chars.length)] }.joinToString("")
    }

    // NEGATIVO: token criptograficamente seguro con SecureRandom // CACOMI-EXPECT: none
    fun generateSessionTokenSecure(): String {
        val sr = SecureRandom()
        val bytes = ByteArray(32)
        sr.nextBytes(bytes)
        return bytes.joinToString("") { "%02x".format(it) }
    }

    // NEGATIVO: OTP seguro con SecureRandom // CACOMI-EXPECT: none
    fun generateOtpSecure(): String {
        val sr = SecureRandom()
        return (sr.nextInt(900000) + 100000).toString()
    }
}
