package com.example.badpracticesappandroid.crypto

import java.security.MessageDigest
import java.security.SecureRandom
import java.util.Random
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

/**
 * Familia 4: Criptografia debil (WeakCipher / WeakKeyDerivation / WeakCryptoExtensions).
 */
object WeakCrypto {

    // BAD: MD5 usado para "seguridad" // CACOMI-EXPECT: WeakCipher
    fun md5(data: ByteArray): ByteArray = MessageDigest.getInstance("MD5").digest(data)

    // BAD: SHA-1 usado para "seguridad" // CACOMI-EXPECT: WeakCipher
    fun sha1(data: ByteArray): ByteArray = MessageDigest.getInstance("SHA-1").digest(data)

    // BAD: DES // CACOMI-EXPECT: WeakCipher
    fun desEncrypt(key: ByteArray, data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("DES/CBC/PKCS5Padding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(key, "DES"), IvParameterSpec(ByteArray(8)))
        return cipher.doFinal(data)
    }

    // BAD: 3DES (DESede) // CACOMI-EXPECT: WeakCipher
    fun tripleDes(key: ByteArray, data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(key, "DESede"))
        return cipher.doFinal(data)
    }

    // BAD: AES en modo ECB // CACOMI-EXPECT: WeakCipher
    fun aesEcb(key: ByteArray, data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(key, "AES"))
        return cipher.doFinal(data)
    }

    // BAD: AES/CBC con IV hardcodeado (todo ceros) // CACOMI-EXPECT: WeakCipher
    fun aesCbcHardcodedIv(key: ByteArray, data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        val iv = IvParameterSpec(byteArrayOf(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(key, "AES"), iv)
        return cipher.doFinal(data)
    }

    // BAD: RSA/ECB/PKCS1Padding // CACOMI-EXPECT: WeakCipher
    fun rsaPkcs1(): Cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding")

    // BAD: PBKDF2 con iteraciones bajisimas (1000) // CACOMI-EXPECT: WeakKeyDerivation
    fun weakPbkdf2(password: CharArray): ByteArray {
        val salt = "0123456789abcdef".toByteArray() // BAD: salt hardcodeado // CACOMI-EXPECT: SaltHash
        val spec = PBEKeySpec(password, salt, 1000, 128)
        return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1").generateSecret(spec).encoded
    }

    // BAD: token/OTP con java.util.Random (no criptografico) // CACOMI-EXPECT: WeakCrypto
    fun weakOtp(): String {
        val rnd = Random()
        return (rnd.nextInt(900000) + 100000).toString()
    }

    // BAD: SecureRandom con seed fija (predecible) // CACOMI-EXPECT: WeakCrypto
    fun seededToken(): ByteArray {
        val sr = SecureRandom()
        sr.setSeed(1234567890L)
        val out = ByteArray(16)
        sr.nextBytes(out)
        return out
    }

    // NEGATIVO: SHA-256 para checksum NO-seguro (integridad, no auth) // CACOMI-EXPECT: none
    fun nonSecurityChecksum(data: ByteArray): ByteArray =
        MessageDigest.getInstance("SHA-256").digest(data) // checksum de cache, no para seguridad
}
