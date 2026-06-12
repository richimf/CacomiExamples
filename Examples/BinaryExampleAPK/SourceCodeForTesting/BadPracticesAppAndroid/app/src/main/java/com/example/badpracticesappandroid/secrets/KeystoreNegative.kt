package com.example.badpracticesappandroid.secrets

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.KeyStore
import javax.crypto.KeyGenerator

/**
 * Familia 3 (NEGATIVO): la clave NO esta hardcodeada; se genera y guarda en el
 * Android Keystore respaldado por hardware. No debe marcarse como secreto.
 *
 * (Equivalente recomendado para datos: EncryptedSharedPreferences de
 *  androidx.security:security-crypto, que cifra claves/valores con una master key
 *  del Keystore.)
 * CACOMI-EXPECT: none
 */
object KeystoreNegative {

    private const val KEY_ALIAS = "secure_aes_key"

    // GOOD: clave generada en el Keystore, nunca expuesta en codigo // CACOMI-EXPECT: none
    fun ensureKey() {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        if (!ks.containsAlias(KEY_ALIAS)) {
            val kg = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
            val spec = KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .build()
            kg.init(spec)
            kg.generateKey()
        }
    }
}
