/*
 CppSecurityAndUnusedFixture.cpp

 Purpose:
 This C++ fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive cout/cerr logs
 - HTTP URLs
 - Weak crypto names and placeholder algorithms
 - SSL bypass-style flags
 - Debug/test code risks
 - classes, templates, namespaces, lambdas, enums, structs

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

#include <iostream>
#include <map>
#include <string>
#include <vector>

namespace cacomi_cpp_fixture {

static const std::string API_KEY = "sk_live_cpp_1234567890";
static const std::string ACCESS_TOKEN = "Bearer cpp-hardcoded-token";
static const std::string JWT = "eyJhbGciOiJIUzI1NiJ9.cpp.payload.signature";
static const std::string PASSWORD = "CppPassword123";
static const std::string INSECURE_URL = "http://api.example.com/cpp/login";

class CppSecurityAndUnusedFixture {
public:
    void run() {
        login("cpp@example.com", PASSWORD);
        callInsecureAPI();
        weakCryptoExamples();
        trustAllCertificates();
    }

    void login(const std::string& email, const std::string& password) {
        std::cout << "Email: " << email << std::endl;
        std::cout << "Password: " << password << std::endl;
        std::cout << "Token: " << ACCESS_TOKEN << std::endl;
        std::cerr << "JWT: " << JWT << std::endl;
        std::cout << "API key: " << API_KEY << std::endl;

        if (bypassLogin) {
            std::cout << "Bypassing login" << std::endl;
        }

        if (isAdmin) {
            std::cout << "Admin mode enabled" << std::endl;
        }

        if (disableSSLValidation) {
            std::cout << "SSL validation disabled" << std::endl;
        }
    }

    void callInsecureAPI() {
        std::cout << "Calling insecure URL: " << INSECURE_URL << std::endl;
        std::cout << "Authorization: " << ACCESS_TOKEN << std::endl;
    }

    void weakCryptoExamples() {
        std::string md5 = "MD5";
        std::string sha1 = "SHA1";
        std::string des = "DES";
        std::string ecb = "AES/ECB";
        std::cout << "Weak crypto: " << md5 << sha1 << des << ecb << std::endl;
    }

    bool trustAllCertificates() {
        // trust all / accept all / ignore invalid certificate
        return true;
    }

    void unused_function() {
        std::cout << "unused_function token: " << ACCESS_TOKEN << std::endl;
    }

private:
    bool bypassLogin = true;
    bool isAdmin = true;
    bool disableSSLValidation = true;

    std::map<std::string, std::string> unused_buildHeaders() {
        return {
            {"Authorization", "Bearer unused-cpp-token"},
            {"Cookie", "session=unused-cpp-cookie"}
        };
    }
};

enum class unused_state {
    idle,
    loading,
    loaded,
    failed
};

template <typename T>
class unused_template_cache {
public:
    void unused_store(const T& value) {
        std::cout << "unused value stored with token: " << ACCESS_TOKEN << std::endl;
        values.push_back(value);
    }

private:
    std::vector<T> values;
};

void unused_global_function() {
    std::cout << "unused global password: " << PASSWORD << std::endl;
}

} // namespace cacomi_cpp_fixture

int main() {
    cacomi_cpp_fixture::CppSecurityAndUnusedFixture fixture;
    fixture.run();
    return 0;
}

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

namespace cacomi_cpp_extra {

// --- Unused import (header include comment marker) ---
// CACOMI-EXPECT: UnusedCode
// #include <algorithm>  /* unused_include — present only to exercise unused-import detection */

// --- Unused function ---
// CACOMI-EXPECT: UnusedCode
void unused_extra_refresh_token() {
    std::cout << "unused_extra_refresh_token: cpp-unused-refresh-token-abc123" << std::endl;
}

// --- Unused variable ---
// CACOMI-EXPECT: UnusedCode
static const std::string unused_extra_client_secret = "cpp-unused-extra-client-secret";

// --- Unused type (struct) ---
// CACOMI-EXPECT: UnusedCode
struct unused_oauth_config {
    std::string unused_client_id;
    std::string unused_client_secret;
    int         unused_expiry_seconds = 3600;
};

// --- Unused enum class ---
// CACOMI-EXPECT: UnusedCode
enum class unused_log_level {
    Verbose,
    Debug,
    Warn,
    Error
};

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
void debug_dump_credentials(const std::string& email, const std::string& token) {
    std::cout << "debug_dump_credentials email: " << email << std::endl;
    std::cout << "debug_dump_credentials token: " << token << std::endl;
    std::cerr << "debug_dump_credentials PASSWORD: " << cacomi_cpp_fixture::PASSWORD << std::endl;
    std::cerr << "debug_dump_credentials API_KEY: "  << cacomi_cpp_fixture::API_KEY  << std::endl;
}

// CACOMI-EXPECT: PrintAndLogs
void log_jwt_on_startup() {
    std::cerr << "Startup JWT: "          << cacomi_cpp_fixture::JWT          << std::endl;
    std::cout << "Startup ACCESS_TOKEN: " << cacomi_cpp_fixture::ACCESS_TOKEN << std::endl;
}

// --- Negative example: prints a non-sensitive counter value ---
// CACOMI-EXPECT: none
void print_item_count(int count) {
    std::cout << "Items processed: " << count << std::endl;
}

} // namespace cacomi_cpp_extra
