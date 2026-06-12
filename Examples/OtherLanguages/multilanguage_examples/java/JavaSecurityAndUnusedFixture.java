/*
 JavaSecurityAndUnusedFixture.java

 Purpose:
 This Java fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive logs
 - HTTP URLs
 - Weak cryptography
 - SSL validation bypass patterns
 - Debug/test code risks
 - Android-style Log usage and standard Java logging

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

package com.cacomi.fixtures.java;

import android.util.Log;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;
import javax.crypto.Cipher;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
import javax.net.ssl.X509TrustManager;

public class JavaSecurityAndUnusedFixture {
    private static final Logger logger = Logger.getLogger(JavaSecurityAndUnusedFixture.class.getName());

    private static final String API_KEY = "sk_live_java_1234567890";
    private static final String ACCESS_TOKEN = "Bearer java-hardcoded-access-token";
    private static final String JWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.java.payload.signature";
    private static final String PASSWORD = "PlainTextPassword123";
    private static final String INSECURE_URL = "http://api.example.com/login";
    private static final String LOCAL_URL = "http://localhost:8080/debug";

    private boolean bypassLogin = true;
    private boolean isAdmin = true;
    private boolean disableSSLValidation = true;

    public void run() throws Exception {
        login("tester@example.com", PASSWORD);
        callInsecureApi();
        weakCryptoExamples("secret-value");
        installTrustAllVerifier();
    }

    public void login(String email, String password) {
        Log.d("Auth", "Email: " + email);
        Log.d("Auth", "Password: " + password);
        Log.i("Auth", "Token: " + ACCESS_TOKEN);
        System.out.println("JWT: " + JWT);
        System.err.println("API Key: " + API_KEY);
        logger.info("Authorization: " + ACCESS_TOKEN);

        if (bypassLogin) {
            Log.w("Auth", "Bypassing login for debug user");
        }

        if (isAdmin) {
            Log.w("Auth", "Admin mode enabled");
        }
    }

    public String callInsecureApi() throws Exception {
        URL url = new URL(INSECURE_URL);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestProperty("Authorization", ACCESS_TOKEN);
        connection.setRequestProperty("X-API-Key", API_KEY);

        Log.d("Network", "Calling URL: " + INSECURE_URL);
        Log.d("Network", "Local URL: " + LOCAL_URL);
        Log.d("Network", "Headers token: " + ACCESS_TOKEN);

        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        return reader.readLine();
    }

    public void weakCryptoExamples(String value) throws Exception {
        MessageDigest md5 = MessageDigest.getInstance("MD5");
        md5.digest(value.getBytes());

        MessageDigest sha1 = MessageDigest.getInstance("SHA-1");
        sha1.digest(value.getBytes());

        Cipher des = Cipher.getInstance("DES");
        Cipher ecb = Cipher.getInstance("AES/ECB/PKCS5Padding");

        Log.d("Crypto", "Weak crypto executed: " + des.getAlgorithm() + ", " + ecb.getAlgorithm());
    }

    public void installTrustAllVerifier() {
        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
            @Override
            public boolean verify(String hostname, SSLSession session) {
                // trust all / accept all / ignore invalid certificate
                return true;
            }
        });
    }

    public X509TrustManager createUnsafeTrustManager() {
        return new X509TrustManager() {
            @Override
            public void checkClientTrusted(X509Certificate[] chain, String authType) { }

            @Override
            public void checkServerTrusted(X509Certificate[] chain, String authType) {
                // intentionally empty: accepts all certificates
            }

            @Override
            public X509Certificate[] getAcceptedIssuers() {
                return new X509Certificate[0];
            }
        };
    }

    // Explicit unused code examples

    public void unused_function() {
        Log.d("Unused", "unused_function token: " + ACCESS_TOKEN);
    }

    private String unused_buildAuthorizationHeader() {
        return "Bearer unused-java-token";
    }

    private Map<String, String> unused_headers() {
        Map<String, String> headers = new HashMap<>();
        headers.put("Authorization", "Bearer unused-secret-token");
        headers.put("Cookie", "session=unused-cookie-value");
        return headers;
    }

    private static class unused_inner_class {
        private final String unused_private_key = "-----BEGIN PRIVATE KEY-----java-unused-key-----END PRIVATE KEY-----";

        void unused_method() {
            System.out.println("unused_private_key: " + unused_private_key);
        }
    }

    private enum unused_state {
        IDLE,
        LOADING,
        SUCCESS,
        FAILURE
    }

    // ===== Cacomi: extra unused-code & logging fixtures =====
    // All values below are FAKE / for testing only.

    // --- Unused import (marked as comment; real import would cause compiler warning) ---
    // CACOMI-EXPECT: UnusedCode
    // import java.util.Optional;  /* unused_import */

    // --- Unused method ---
    // CACOMI-EXPECT: UnusedCode
    private String unused_extra_refresh_token() {
        return "java-unused-refresh-token-abc123";
    }

    // --- Unused variable ---
    // CACOMI-EXPECT: UnusedCode
    private static final String unused_extra_client_secret = "java-unused-extra-client-secret";

    // --- Unused interface (inner) ---
    // CACOMI-EXPECT: UnusedCode
    private interface unused_audit_logger {
        void unused_logEvent(String event, Map<String, String> metadata);
    }

    // --- Unused nested class ---
    // CACOMI-EXPECT: UnusedCode
    private static class unused_oauth_config {
        final String unusedClientId     = "java-unused-client-id";
        final String unusedClientSecret = "java-unused-client-secret";
        final int    unusedExpiry       = 3600;
    }

    // --- Print/log positives ---
    // CACOMI-EXPECT: PrintAndLogs
    public void debugDumpCredentials(String email, String token) {
        System.out.println("debugDumpCredentials email: " + email);
        System.out.println("debugDumpCredentials token: " + token);
        System.err.println("debugDumpCredentials PASSWORD: " + PASSWORD);
        logger.info("debugDumpCredentials API_KEY: " + API_KEY);
        Log.d("Debug", "debugDumpCredentials JWT: " + JWT);
    }

    // CACOMI-EXPECT: PrintAndLogs
    public void logJWTOnStartup() {
        System.err.println("Startup JWT: " + JWT);
        logger.warning("Startup ACCESS_TOKEN: " + ACCESS_TOKEN);
        Log.e("Startup", "Startup API_KEY: " + API_KEY);
    }

    // --- Negative example: logs a non-sensitive status string ---
    // CACOMI-EXPECT: none
    public void logItemCount(int count) {
        System.out.println("Items processed: " + count);
    }
}
