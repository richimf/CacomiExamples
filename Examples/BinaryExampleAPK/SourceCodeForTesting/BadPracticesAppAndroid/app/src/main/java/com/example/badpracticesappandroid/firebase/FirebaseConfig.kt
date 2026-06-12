package com.example.badpracticesappandroid.firebase

/**
 * Familia: Secretos hardcodeados — configuracion de Firebase / Google Services.
 * Valores FAKE / DUMMY, exclusivamente para pruebas de Cacomi. NO son credenciales reales.
 * OWASP M9 – Insecure Data Storage / Hardcoded Secrets.
 */
object FirebaseConfig {

    // BAD: Firebase Realtime Database URL hardcodeada // CACOMI-EXPECT: SecretPattern
    const val FIREBASE_DB_URL = "https://fake-project-default-rtdb.firebaseio.com"

    // BAD: Firebase/Google API key (patron AIza...) // CACOMI-EXPECT: SecretPattern
    const val FIREBASE_API_KEY = "AIzaSyFAKE-DO-NOT-USE-00000000000000000EX"

    // BAD: Firebase project id expuesto en codigo // CACOMI-EXPECT: SecretPattern
    const val FIREBASE_PROJECT_ID = "fake-project-id-000000"

    // BAD: Firebase storage bucket hardcodeado con clave de app // CACOMI-EXPECT: SecretPattern
    const val FIREBASE_STORAGE_BUCKET = "fake-project-id-000000.appspot.com"

    // BAD: Firebase app id (tipico de google-services.json) // CACOMI-EXPECT: SecretPattern
    const val FIREBASE_APP_ID = "1:000000000000:android:FAKEAPPID0000000000000"

    // BAD: Firebase Cloud Messaging (FCM) server key // CACOMI-EXPECT: SecretPattern
    const val FCM_SERVER_KEY = "AAAA_FAKE_FCM_SERVER_KEY:APA91bFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEDONOTUSE"

    // BAD: Google OAuth 2.0 client id / secret hardcodeados // CACOMI-EXPECT: SecretPattern
    const val GOOGLE_CLIENT_ID = "000000000000-fakeexample000000000000.apps.googleusercontent.com"
    const val GOOGLE_CLIENT_SECRET = "GOCSPX-FAKEEXAMPLESECRET000000000EX" // CACOMI-EXPECT: SecretPattern

    // BAD: google-services.json snippet con clave reproducida en codigo fuente // CACOMI-EXPECT: SecretPattern
    val GOOGLE_SERVICES_JSON_SNIPPET = """
        {
          "project_info": {
            "project_number": "000000000000",
            "firebase_url": "https://fake-project-default-rtdb.firebaseio.com",
            "project_id": "fake-project-id-000000",
            "storage_bucket": "fake-project-id-000000.appspot.com"
          },
          "client": [{
            "api_key": [{"current_key": "AIzaSyFAKE-DO-NOT-USE-00000000000000000EX"}]
          }]
        }
    """.trimIndent() // CACOMI-EXPECT: SecretPattern

    // NEGATIVO: nombre del proyecto (sin valor secreto) // CACOMI-EXPECT: none
    const val FIREBASE_DISPLAY_NAME = "BadPracticesApp"

    // NEGATIVO: URL publica de documentacion, sin credencial // CACOMI-EXPECT: none
    const val FIREBASE_DOCS_URL = "https://firebase.google.com/docs"
}
