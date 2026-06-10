//
//  InsecureExtras.swift
//  CalculatorDemo
//
//  Cacomi fixture: deliberately insecure helpers bolted onto the demo app so the
//  static analyzer has positive cases to find in an otherwise "clean" project.
//  ALL VALUES ARE FAKE / NON-FUNCTIONAL — intentional bad practice for testing only.
//

import Foundation
import CryptoKit
import CommonCrypto
#if canImport(WebKit)
import WebKit
#endif

// MARK: - Hardcoded secrets (M1)

enum CalcSecrets {
    // CACOMI-EXPECT[SecretPatternRule|high]: AWS access key id
    static let awsKey = "AKIA3KZ8R2QW9TUV6BCD"
    // CACOMI-EXPECT[SecretPatternRule|high]: Stripe live secret key
    static let stripe = "sk_live_51Hb9kLcalcQZ7vR2tMnP0aXyZ8wQ"
    // CACOMI-EXPECT[SecretPatternRule|high]: Azure AD client secret
    static let azure = "Qj8Q~aB3cDeFgHiJkLmNoPqRsTuVwXyZ012345"
    // CACOMI-EXPECT[SecretPatternRule|high]: basic-auth credentials in URL
    static let basicAuth = "https://admin:s3cr3tP4ssw0rd@api.example.com/calc"
    // CACOMI-EXPECT[SecretPatternRule|critical]: RSA private key in source
    static let privateKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpQIBAAKCAQEAcalcVALIDATIONfixturePRIVATEkeyNOTrealdata00000000
    -----END RSA PRIVATE KEY-----
    """
    // CACOMI-NEGATIVE[SecretPatternRule]: plain UUID is not a secret
    static let requestId = "550e8400-e29b-41d4-a716-446655440000"
}

// MARK: - Insecure storage (M9)

enum CalcStorage {
    // CACOMI-EXPECT[InsecureStorageRule|high]: auth token written to UserDefaults
    static func persist(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    // CACOMI-EXPECT[InsecureStorageRule|high]: password written to UserDefaults
    static func persist(password: String) {
        UserDefaults.standard.set(password, forKey: "password")
    }
    // CACOMI-EXPECT[InsecureStorageRule|high]: file written with data protection disabled
    static func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: [.noFileProtection])
    }
    // CACOMI-NEGATIVE[InsecureStorageRule]: non-sensitive UI preference is fine
    static func saveTheme(_ name: String) {
        UserDefaults.standard.set(name, forKey: "themeName")
    }
}

// MARK: - Insecure communication (M5)

enum CalcNetwork {
    // CACOMI-EXPECT[insecureHTTP|high]: cleartext endpoint
    static let api = URL(string: "http://api.example.com/v1/login")
    // CACOMI-NEGATIVE[insecureHTTP]: localhost over http is low/informational only
    static let local = URL(string: "http://localhost:8080/debug")

    // CACOMI-EXPECT[TLSTrustBypassRule|critical]: accept-all server trust
    final class TrustAll: NSObject, URLSessionDelegate {
        func urlSession(_ s: URLSession,
                        didReceive challenge: URLAuthenticationChallenge,
                        completionHandler ch: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if let trust = challenge.protectionSpace.serverTrust {
                ch(.useCredential, URLCredential(trust: trust))
            } else {
                ch(.performDefaultHandling, nil)
            }
        }
    }
}

// MARK: - Weak cryptography (M10)

enum CalcCrypto {
    // CACOMI-EXPECT[WeakCipherRule|high]: MD5 used for hashing
    static func md5(_ s: String) -> String {
        Insecure.MD5.hash(data: Data(s.utf8)).map { String(format: "%02x", $0) }.joined()
    }
    // CACOMI-EXPECT[WeakCipherRule|high]: AES-ECB mode option
    static let ecbMode = kCCOptionECBMode
    // CACOMI-NEGATIVE[WeakCipherRule]: SHA-256 is acceptable for integrity
    static func sha256(_ s: String) -> String {
        SHA256.hash(data: Data(s.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Sensitive logging (M8)

enum CalcLogging {
    // CACOMI-EXPECT[LogParser|critical]: token logged
    static func log1(_ token: String) { NSLog("auth token = \(token)") }
    // CACOMI-EXPECT[LogParser|medium]: conditional-wrapped password log
    static func log2(_ password: String) {
        if ProcessInfo.processInfo.environment["DBG"] != nil { print("password=\(password)") }
    }
    // CACOMI-NEGATIVE[LogParser]: non-sensitive log
    static func log3(_ count: Int) { print("loaded \(count) rows") }
}

// MARK: - Input/output validation (M4)

enum CalcInjection {
    // CACOMI-EXPECT[InjectionRules|high]: NSPredicate format-string injection
    static func find(_ userInput: String) -> NSPredicate {
        NSPredicate(format: "name == \(userInput) AND active == 1")
    }
    // CACOMI-NEGATIVE[InjectionRules]: parameterised predicate
    static func findSafe(_ userInput: String) -> NSPredicate {
        NSPredicate(format: "name == %@ AND active == 1", userInput)
    }
}

// MARK: - WebView misuse (M8)

#if canImport(WebKit)
enum CalcWebView {
    // CACOMI-EXPECT[WebViewMisuseExtrasRule|high]: JavaScript enabled on WKWebView
    static func make() -> WKWebView {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = true
        let cfg = WKWebViewConfiguration()
        cfg.preferences = prefs
        return WKWebView(frame: .zero, configuration: cfg)
    }
}
#endif
