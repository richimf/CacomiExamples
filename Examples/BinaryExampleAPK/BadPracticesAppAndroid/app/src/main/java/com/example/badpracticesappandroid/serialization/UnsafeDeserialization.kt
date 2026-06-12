package com.example.badpracticesappandroid.serialization

import com.google.gson.Gson
import java.io.ByteArrayInputStream
import java.io.ObjectInputStream

/**
 * Familia: Validacion de entradas / Deserializacion insegura — ObjectInputStream sobre bytes
 * no confiables y cast inseguro de Gson. Permite ejecucion de codigo arbitrario o crashes
 * controlados por el atacante.
 * OWASP M4 – Insufficient Input/Output Validation / CWE-502.
 */
object UnsafeDeserialization {

    // BAD: ObjectInputStream.readObject sobre bytes arbitrarios de la red // CACOMI-EXPECT: InputValidation
    fun deserializeFromNetwork(rawBytes: ByteArray): Any? {
        // Sin validacion de origen ni lista blanca de clases
        val ois = ObjectInputStream(ByteArrayInputStream(rawBytes)) // CACOMI-EXPECT: InputValidation
        return ois.readObject() // gadget chain posible si hay dependencias en classpath
    }

    // BAD: ObjectInputStream sobre datos de SharedPreferences (potencialmente manipulados) // CACOMI-EXPECT: InputValidation
    fun deserializeFromPrefs(serializedData: String): Any? {
        val bytes = android.util.Base64.decode(serializedData, android.util.Base64.DEFAULT)
        val ois = ObjectInputStream(ByteArrayInputStream(bytes)) // CACOMI-EXPECT: InputValidation
        return ois.readObject()
    }

    // BAD: cast sin validacion de tipo en Gson (ClassCastException / datos malformados) // CACOMI-EXPECT: InputValidation
    @Suppress("UNCHECKED_CAST")
    fun unsafeGsonCast(json: String): Map<String, Any> {
        val gson = Gson()
        // BAD: cast directo desde Any sin verificar la estructura // CACOMI-EXPECT: InputValidation
        return gson.fromJson(json, Any::class.java) as Map<String, Any>
    }

    // BAD: deserializacion de Intent extra sin comprobacion de tipo // CACOMI-EXPECT: InputValidation
    fun deserializeIntentExtra(intent: android.content.Intent): Any? {
        val bytes = intent.getByteArrayExtra("payload") ?: return null
        // BAD: payload de intent puede ser inyectado por otra app // CACOMI-EXPECT: InputValidation
        val ois = ObjectInputStream(ByteArrayInputStream(bytes))
        return ois.readObject()
    }

    // NEGATIVO: parse JSON seguro con tipo concreto conocido y manejo de excepcion // CACOMI-EXPECT: none
    data class UserProfile(val id: String, val name: String)

    fun safeGsonParse(json: String): UserProfile? {
        return try {
            Gson().fromJson(json, UserProfile::class.java)
        } catch (e: Exception) {
            null
        }
    }
}
