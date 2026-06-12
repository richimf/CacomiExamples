package com.example.badpracticesappandroid.serialization

import org.json.JSONObject
import java.io.ByteArrayInputStream
import java.io.ObjectInputStream

/**
 * Familia: Validacion de entradas / Deserializacion insegura — ObjectInputStream sobre bytes
 * no confiables y cast inseguro de JSON. Permite ejecucion de codigo arbitrario o crashes
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

    // BAD: cast sin validacion de tipo en JSON parseado (ClassCastException / datos malformados) // CACOMI-EXPECT: InputValidation
    @Suppress("UNCHECKED_CAST")
    fun unsafeJsonCast(json: String): Map<String, Any> {
        // BAD: se asume estructura/tipo sin verificar; el atacante controla el JSON // CACOMI-EXPECT: InputValidation
        val parsed = JSONObject(json)
        return parsed.get("payload") as Map<String, Any>
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

    fun safeJsonParse(json: String): UserProfile? {
        return try {
            val obj = JSONObject(json)
            UserProfile(
                id = obj.getString("id"),
                name = obj.getString("name")
            )
        } catch (e: Exception) {
            null
        }
    }
}
