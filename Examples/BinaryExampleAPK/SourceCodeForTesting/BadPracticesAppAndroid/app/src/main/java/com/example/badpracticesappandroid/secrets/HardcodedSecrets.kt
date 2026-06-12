package com.example.badpracticesappandroid.secrets

/**
 * Familia 3: Secretos hardcodeados (SecretPattern / HighEntropy / SaltHash).
 * TODOS los valores son DUMMY / de ejemplo, NO son credenciales reales.
 */
object HardcodedSecrets {

    // BAD: AWS access key id (patron) // CACOMI-EXPECT: SecretPattern
    const val AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"

    // BAD: AWS secret access key (alta entropia) // CACOMI-EXPECT: HighEntropy
    const val AWS_SECRET = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    // BAD: Google API key (patron AIza...) // CACOMI-EXPECT: SecretPattern
    const val GOOGLE_API_KEY = "AIzaSyA-EXAMPLE-DO-NOT-USE-1234567890abcdEX"

    // BAD: token / password / client secret // CACOMI-EXPECT: SecretPattern
    const val PASSWORD = "SuperSecret123!"
    const val CLIENT_SECRET = "client_secret_0a1b2c3d4e5f6071829304a5b6c7d8e9"

    // BAD: header Authorization Bearer hardcodeado // CACOMI-EXPECT: SecretPattern
    const val AUTH_HEADER = "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.fakefakefake.signaturefake"

    // BAD: database URL con credenciales // CACOMI-EXPECT: SecretPattern
    const val DB_URL = "postgres://admin:SuperSecret123@db.example.com:5432/prod"

    // BAD: webhook URL // CACOMI-EXPECT: SecretPattern
    const val WEBHOOK = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

    // BAD: clave privada PEM (truncada, dummy) // CACOMI-EXPECT: SecretPattern/HighEntropy
    const val PRIVATE_KEY_PEM = """
        -----BEGIN RSA PRIVATE KEY-----
        MIIEpAIBAAKCAQEAxFAKEFAKEEXAMPLEKEYDONOTUSE000000000000000000000000
        00000TRUNCATEDEXAMPLE0000000000000000000000000000000000000000000000
        -----END RSA PRIVATE KEY-----
    """

    // BAD/SaltHash: salt e IV hardcodeados pasados a derivacion de clave // CACOMI-EXPECT: SaltHash
    val HARDCODED_SALT = "0123456789abcdef".toByteArray()
    val HARDCODED_IV = byteArrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

    // BAD: literal string que sobrevive al DEX (para el scan del APK) // CACOMI-EXPECT: SecretPattern
    fun bakedIntoDex(): String = "AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    // NEGATIVO: un UUID plano no es un secreto // CACOMI-EXPECT: none
    const val REQUEST_ID = "550e8400-e29b-41d4-a716-446655440000"

    // NEGATIVO: un SHA de commit publico no es un secreto // CACOMI-EXPECT: none
    const val GIT_COMMIT_SHA = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b"
}
