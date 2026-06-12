package com.example.badpracticesappandroid.privacy

/**
 * Familia 13: PII hardcodeada (PrivacyPermission / PII).
 * Todos los datos son FICTICIOS / de ejemplo.
 */
object PiiData {
    // BAD: email hardcodeado // CACOMI-EXPECT: PII
    const val SUPPORT_EMAIL = "john.doe@example.com"
    // BAD: telefono hardcodeado // CACOMI-EXPECT: PII
    const val PHONE = "+1-202-555-0173"
    // BAD: SSN de ejemplo // CACOMI-EXPECT: PII
    const val SSN = "123-45-6789"
    // BAD: IBAN de ejemplo // CACOMI-EXPECT: PII
    const val IBAN = "DE89370400440532013000"
    // BAD: tarjeta de ejemplo, Luhn valido (test number) // CACOMI-EXPECT: PII
    const val CARD = "4111111111111111"

    // NEGATIVO: 16 digitos que FALLAN el check de Luhn (no es tarjeta) // CACOMI-EXPECT: none
    const val NOT_A_CARD = "1234567890123456"

    // NEGATIVO: area SSN reservada (000-..) no es un SSN real // CACOMI-EXPECT: none
    const val RESERVED_SSN = "000-12-3456"
}
