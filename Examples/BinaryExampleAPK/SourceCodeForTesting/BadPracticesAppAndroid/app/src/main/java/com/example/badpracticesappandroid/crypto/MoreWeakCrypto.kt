package com.example.badpracticesappandroid.crypto

import android.util.Base64
import java.security.MessageDigest
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

/**
 * Familia crypto (variantes extra): cifradores/algoritmos debiles adicionales
 * y clave/IV hardcodeados. TODOS los valores son DUMMY / de ejemplo.
 */
object MoreWeakCrypto {

    // BAD: clave de cifrado hardcodeada // CACOMI-EXPECT: SecretPattern / WeakCrypto
    private const val HARDCODED_KEY = "1234567890abcdef" // 16 bytes
    private val FIXED_IV = ByteArray(16) // IV todo-ceros, reutilizado

    // BAD: RC4 es un cifrador roto // CACOMI-EXPECT: WeakCipher
    fun rc4(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("RC4")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(HARDCODED_KEY.toByteArray(), "RC4"))
        return cipher.doFinal(data)
    }

    // BAD: Blowfish en modo ECB // CACOMI-EXPECT: WeakCipher
    fun blowfishEcb(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("Blowfish/ECB/PKCS5Padding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(HARDCODED_KEY.toByteArray(), "Blowfish"))
        return cipher.doFinal(data)
    }

    // BAD: AES-CBC con IV fijo y clave hardcodeada // CACOMI-EXPECT: WeakCrypto
    fun aesCbcFixedIv(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(
            Cipher.ENCRYPT_MODE,
            SecretKeySpec(HARDCODED_KEY.toByteArray(), "AES"),
            IvParameterSpec(FIXED_IV)
        )
        return cipher.doFinal(data)
    }

    // BAD: MD4 / MD5 para "hash de password" // CACOMI-EXPECT: WeakCipher
    fun weakHash(input: String): String {
        val md = MessageDigest.getInstance("MD5")
        return Base64.encodeToString(md.digest(input.toByteArray()), Base64.NO_WRAP)
    }

    // BAD: SecureRandom sembrado con semilla constante // CACOMI-EXPECT: WeakCrypto
    fun predictableToken(): Long {
        val rng = SecureRandom()
        rng.setSeed(1234L)
        return rng.nextLong()
    }

    // NEGATIVO: SHA-256 para checksum de integridad // CACOMI-EXPECT: none
    fun checksum(input: ByteArray): ByteArray {
        return MessageDigest.getInstance("SHA-256").digest(input)
    }

    // NEGATIVO: AES-GCM con clave/nonce generados aleatoriamente // CACOMI-EXPECT: none
    fun aesGcmRandom(data: ByteArray): ByteArray {
        val key = ByteArray(32).also { SecureRandom().nextBytes(it) }
        val nonce = ByteArray(12).also { SecureRandom().nextBytes(it) }
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(
            Cipher.ENCRYPT_MODE,
            SecretKeySpec(key, "AES"),
            javax.crypto.spec.GCMParameterSpec(128, nonce)
        )
        return cipher.doFinal(data)
    }
}
