/*
 C_SecurityAndUnusedFixture.c

 Purpose:
 This C fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive printf/fprintf logs
 - HTTP URLs as strings
 - Weak crypto names and placeholder calls
 - Debug/test flags
 - structs, enums, function pointers, macros

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define API_KEY "sk_live_c_1234567890"
#define ACCESS_TOKEN "Bearer c-hardcoded-token"
#define JWT "eyJhbGciOiJIUzI1NiJ9.c.payload.signature"
#define PASSWORD "CPassword123"
#define INSECURE_URL "http://api.example.com/c/login"

static bool bypassLogin = true;
static bool isAdmin = true;
static bool disableSSLValidation = true;

typedef struct {
    const char *email;
    const char *token;
} CProfile;

void login(const char *email, const char *password) {
    printf("Email: %s\n", email);
    printf("Password: %s\n", password);
    printf("Token: %s\n", ACCESS_TOKEN);
    fprintf(stderr, "JWT: %s\n", JWT);
    printf("API key: %s\n", API_KEY);

    if (bypassLogin) {
        printf("Bypassing login\n");
    }

    if (isAdmin) {
        printf("Admin mode enabled\n");
    }

    if (disableSSLValidation) {
        printf("SSL validation disabled\n");
    }
}

void call_insecure_api(void) {
    printf("Calling insecure URL: %s\n", INSECURE_URL);
    printf("Authorization: %s\n", ACCESS_TOKEN);
}

void weak_crypto_examples(void) {
    const char *md5 = "MD5";
    const char *sha1 = "SHA1";
    const char *des = "DES";
    const char *ecb = "AES/ECB";
    printf("Weak crypto: %s %s %s %s\n", md5, sha1, des, ecb);
}

bool trust_all_certificates(void) {
    /* trust all / accept all / ignore invalid certificate */
    return true;
}

void unused_function(void) {
    printf("unused_function token: %s\n", ACCESS_TOKEN);
}

static const char *unused_build_authorization_header(void) {
    return "Bearer unused-c-token";
}

typedef enum {
    unused_state_idle,
    unused_state_loading,
    unused_state_loaded,
    unused_state_failed
} unused_state;

int main(void) {
    login("c@example.com", PASSWORD);
    call_insecure_api();
    weak_crypto_examples();
    return 0;
}

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

// --- Unused import (header) ---
// CACOMI-EXPECT: UnusedCode
// #include <math.h>   /* unused_include — included only to exercise unused-import detection */

// --- Unused function ---
// CACOMI-EXPECT: UnusedCode
void unused_extra_refresh_token(void) {
    const char *refresh = "c-unused-refresh-token-abc123";
    printf("unused_extra_refresh_token: %s\n", refresh);
}

// --- Unused variable ---
// CACOMI-EXPECT: UnusedCode
static const char *unused_extra_secret = "c-unused-extra-secret-value";

// --- Unused type (struct) ---
// CACOMI-EXPECT: UnusedCode
typedef struct {
    const char *unused_client_id;
    const char *unused_client_secret;
    int         unused_expiry_seconds;
} unused_oauth_config;

// --- Unused enum ---
// CACOMI-EXPECT: UnusedCode
typedef enum {
    unused_log_level_verbose,
    unused_log_level_debug,
    unused_log_level_warn,
    unused_log_level_error
} unused_log_level;

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
void debug_dump_credentials(const char *email, const char *token) {
    printf("debug_dump_credentials email: %s\n", email);
    printf("debug_dump_credentials token: %s\n", token);
    fprintf(stderr, "debug_dump_credentials PASSWORD: %s\n", PASSWORD);
    fprintf(stderr, "debug_dump_credentials API_KEY: %s\n", API_KEY);
}

// CACOMI-EXPECT: PrintAndLogs
void log_jwt_on_startup(void) {
    fprintf(stderr, "Startup JWT: %s\n", JWT);
    printf("Startup ACCESS_TOKEN: %s\n", ACCESS_TOKEN);
}

// --- Negative example: prints a non-sensitive counter value ---
// CACOMI-EXPECT: none
void print_item_count(int count) {
    printf("Items processed: %d\n", count);
}
