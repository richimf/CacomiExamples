package com.example.badpracticesappandroid.secrets

/**
 * Familia 3 (P1): secretos hardcodeados nuevos para paridad con
 * ValidationFixtures/apple/SecretsAuth.swift y droid/MainSecrets.kt.
 *
 * TODOS los valores son DUMMY / de ejemplo, NO son credenciales reales.
 */
object P1Secrets {

    // BAD: Azure AD client secret // CACOMI-EXPECT: SecretPattern
    const val AZURE_CLIENT_SECRET = "Qj8Q~aB3cDeFgHiJkLmNoPqRsTuVwXyZ012345"

    // BAD: Supabase project URL // CACOMI-EXPECT: SecretPattern
    const val SUPABASE_URL = "https://abcdefghijklmnopqrst.supabase.co"

    // BAD: GitLab runner authentication token // CACOMI-EXPECT: SecretPattern
    const val GITLAB_RUNNER = "glrt-AbCdEfGhIjKlMnOpQrS1"

    // BAD: HTTP Basic-auth credentials embebidas en URL // CACOMI-EXPECT: SecretPattern
    const val BASIC_AUTH_URL = "https://admin:s3cr3tP4ssw0rd@internal.example.com/api"

    // BAD: credenciales SMTP embebidas en URL // CACOMI-EXPECT: SecretPattern
    const val SMTP_URL = "smtp://mailer:Pa55w0rdMailer@smtp.example.com:587"

    // BAD: Twilio account SID + auth token // CACOMI-EXPECT: SecretPattern
    const val TWILIO_SID = "AC0123456789abcdef0123456789abcdef"
    const val TWILIO_TOKEN = "fakeCacomiTwilioAuthToken0123456789ab"

    // BAD: SendGrid API key // CACOMI-EXPECT: SecretPattern
    const val SENDGRID = "SG.FAKEcacomiSendGridKeyAAAAAAAAAA.BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"

    // BAD: bloque PEM de certificado (publico, informativo) // CACOMI-EXPECT: SecretPattern
    const val PEM_CERTIFICATE = """
        -----BEGIN CERTIFICATE-----
        MIIBkTCB+wIJAKh3cacomiVALIDATIONfixtureNOTrealCERTdataxxxxxxxx0000
        -----END CERTIFICATE-----
    """

    // BAD: OAuth implicit flow (response_type=token) // CACOMI-EXPECT: SecretPattern
    const val OAUTH_IMPLICIT_URL =
        "https://idp.example.com/authorize?client_id=app&response_type=token"

    // BAD: OAuth redirect_uri sobre http cleartext // CACOMI-EXPECT: SecretPattern
    const val OAUTH_INSECURE_REDIRECT =
        "https://idp.example.com/authorize?client_id=app&redirect_uri=http://app.example.com/callback"

    // BAD: client_secret OAuth embebido // CACOMI-EXPECT: SecretPattern
    const val OAUTH_CLIENT_SECRET = "abc123def456ghi789jkl012mno345"

    // NEGATIVO: Authorization Code + PKCE (forma segura) // CACOMI-EXPECT: none
    const val OAUTH_SECURE_URL =
        "https://idp.example.com/authorize?client_id=app&response_type=code&code_challenge=xyz"

    // NEGATIVO: redirect_uri https (forma segura) // CACOMI-EXPECT: none
    const val OAUTH_SECURE_REDIRECT =
        "https://idp.example.com/authorize?redirect_uri=https://app.example.com/callback"

    // NEGATIVO: placeholder de documentacion, no es un secreto real // CACOMI-EXPECT: none
    const val PLACEHOLDER = "YOUR_API_KEY_HERE"

    // BAD: literal que sobrevive al DEX (scan del APK) // CACOMI-EXPECT: SecretPattern
    fun bakedIntoDex(): String = "$AZURE_CLIENT_SECRET|$GITLAB_RUNNER|$BASIC_AUTH_URL"
}
