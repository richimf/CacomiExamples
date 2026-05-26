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
