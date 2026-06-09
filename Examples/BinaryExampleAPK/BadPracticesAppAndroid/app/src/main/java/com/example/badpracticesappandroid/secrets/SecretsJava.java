package com.example.badpracticesappandroid.secrets;

/**
 * Familia 3 en Java: secretos hardcodeados. Valores DUMMY.
 */
public class SecretsJava {

    // BAD: API key hardcodeada en Java // CACOMI-EXPECT: SecretPattern
    public static final String STRIPE_KEY = "sk_live_EXAMPLE0000000000000000000000";

    // BAD: token de servicio // CACOMI-EXPECT: HighEntropy
    public static final String SERVICE_TOKEN = "ghp_EXAMPLEexampleEXAMPLEexample0000000000";

    // BAD: password hardcodeada // CACOMI-EXPECT: SecretPattern
    private static final String ADMIN_PASSWORD = "admin123";

    public String basicAuthHeader() {
        // BAD: credenciales concatenadas en header
        return "Basic " + "YWRtaW46YWRtaW4xMjM="; // base64("admin:admin123") dummy
    }
}
