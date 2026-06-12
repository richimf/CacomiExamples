package com.example.badpracticesappandroid.cloud

/**
 * Familia: Secretos hardcodeados — credenciales de servicios cloud (Azure, GCP, Supabase, Sentry).
 * Todos los valores son FAKE / DUMMY. NO son credenciales reales.
 * OWASP M9 – Insecure Data Storage / Hardcoded Secrets.
 */
object CloudCredentials {

    // BAD: Azure Storage connection string completa // CACOMI-EXPECT: SecretPattern
    const val AZURE_STORAGE_CONN_STRING =
        "DefaultEndpointsProtocol=https;AccountName=fakeaccount;AccountKey=FAKE/ACCOUNT/KEY+FAKEEXAMPLEDONOTUSE==;EndpointSuffix=core.windows.net"

    // BAD: Azure AD client id + secret // CACOMI-EXPECT: SecretPattern
    const val AZURE_CLIENT_ID = "00000000-0000-0000-0000-FAKEEXAMPLE00"
    const val AZURE_CLIENT_SECRET = "FAKE~AzureClientSecret.DO_NOT_USE-00000000000" // CACOMI-EXPECT: SecretPattern
    const val AZURE_TENANT_ID = "00000000-0000-0000-0000-FAKETENANTIDEX"

    // BAD: GCP service-account JSON hardcodeado (snippet) -- alta entropia // CACOMI-EXPECT: HighEntropy
    val GCP_SERVICE_ACCOUNT_JSON = """
        {
          "type": "service_account",
          "project_id": "fake-gcp-project",
          "private_key_id": "0000fakekey0000",
          "private_key": "-----BEGIN RSA PRIVATE KEY-----\nFAKEFAKEFAKEEXAMPLEDONOTUSE0000000000000000000000000000000000000000\n-----END RSA PRIVATE KEY-----\n",
          "client_email": "fake-sa@fake-gcp-project.iam.gserviceaccount.com",
          "client_id": "000000000000000000000",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token"
        }
    """.trimIndent() // CACOMI-EXPECT: SecretPattern

    // BAD: Supabase project URL + anon key (JWT publico, alta entropia) // CACOMI-EXPECT: SecretPattern
    const val SUPABASE_URL = "https://fakeprojectid.supabase.co"
    const val SUPABASE_ANON_KEY =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYwMDAwMDAwMCwiZXhwIjo5OTk5OTk5OTk5fQ.FAKE_SIGNATURE_DO_NOT_USE" // CACOMI-EXPECT: SecretPattern

    // BAD: Supabase service-role key (privilegios elevados) // CACOMI-EXPECT: SecretPattern
    const val SUPABASE_SERVICE_ROLE_KEY =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjAwMDAwMDAwfQ.FAKE_SERVICE_ROLE_SIGNATURE_DONOT_USE" // CACOMI-EXPECT: HighEntropy

    // BAD: Sentry DSN con clave embebida // CACOMI-EXPECT: SecretPattern
    const val SENTRY_DSN = "https://fakekey0000000000000000000000000@o000000.ingest.sentry.io/0000000"

    // BAD: Datadog API key // CACOMI-EXPECT: SecretPattern
    const val DATADOG_API_KEY = "FAKE_DATADOG_API_KEY_00000000000000000000000000000000"

    // NEGATIVO: nombre de region sin credencial // CACOMI-EXPECT: none
    const val AZURE_REGION = "eastus"

    // NEGATIVO: nombre del bucket publico de GCS (sin clave) // CACOMI-EXPECT: none
    const val GCS_PUBLIC_BUCKET = "gs://fake-public-assets-bucket"
}
