//
//  SecretsCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: SecretPattern / HighEntropy / SaltHash.
//  All values are DUMMY but follow the public format of the provider.
//

import Foundation
import Security
import CommonCrypto

enum SecretsCacomi {

    // BAD: AWS access key (dummy)                        // CACOMI-EXPECT: SecretPattern
    static let awsAccessKeyId = "AKIAIOSFODNN7EXAMPLE"

    // BAD: AWS secret access key (dummy)                 // CACOMI-EXPECT: SecretPattern
    static let awsSecretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    // BAD: Stripe live key (dummy)                       // CACOMI-EXPECT: SecretPattern
    static let stripeLive = "sk_live_0000000000000000000000"

    // BAD: hardcoded auth header                         // CACOMI-EXPECT: SecretPattern
    static let authHeader = "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.cacomi.dummySig"

    // BAD: DB URL with credentials                       // CACOMI-EXPECT: SecretPattern
    static let dbUrl = "postgres://user:hunter2@db.fake-cacomi.com:5432/appdb"

    // BAD: webhook URL with embedded secret              // CACOMI-EXPECT: SecretPattern
    static let slackWebhook = "https://hooks.slack.com/services/T00000000/B00000000/DUMMYwebhookTokenForCacomi"

    // BAD: hardcoded client_secret                       // CACOMI-EXPECT: SecretPattern
    static let clientSecret = "cacomi_dummy_client_secret_zxcvbnmlkjhgfdsa"

    // BAD: hardcoded password                            // CACOMI-EXPECT: SecretPattern
    static let dbPassword = "hunter2!cacomi"

    // BAD: PEM private key (dummy, truncated)            // CACOMI-EXPECT: SecretPattern
    static let pemKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpQIBAAKCAQEADUMMYcacomiPemKey1234567890abcdefghijklmnopqr
    -----END RSA PRIVATE KEY-----
    """

    // BAD: high-entropy blob ~40 chars                   // CACOMI-EXPECT: HighEntropy
    static let highEntropyBlob = "aZ9q+P3sL2vK1nM7oR8tU0yX5cD6gH4jK8lQwErT"

    // BAD: hardcoded salt fed into PBKDF2                // CACOMI-EXPECT: SaltHash
    static let hardcodedSalt = "cacomi_static_salt"

    // BAD: hardcoded IV fed into symmetric cipher        // CACOMI-EXPECT: SaltHash
    static let hardcodedIV = Data([UInt8](repeating: 0x00, count: 16))

    static func deriveWithHardcodedSalt(_ password: String) -> Data {
        let pw = Array(password.utf8)
        let salt = Array(hardcodedSalt.utf8)
        var out = [UInt8](repeating: 0, count: 32)
        // BAD: derivation seeded by hardcoded salt        // CACOMI-EXPECT: SaltHash
        _ = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            pw, pw.count, salt, salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            200_000,
            &out, out.count
        )
        return Data(out)
    }

    // MARK: - Negatives

    static func readFromEnv() -> String? {
        // GOOD: secret pulled from process environment     // CACOMI-EXPECT: none
        return ProcessInfo.processInfo.environment["CACOMI_API_TOKEN"]
    }

    static func readFromKeychain() -> Data? {
        // GOOD: secret read from Keychain, not embedded   // CACOMI-EXPECT: none
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "session_token",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        var ref: AnyObject?
        _ = SecItemCopyMatching(q as CFDictionary, &ref)
        return ref as? Data
    }

    // Keep a binary-resident reference to every BAD secret so the IPA
    // scan still finds them after dead-code stripping.
    static func materialize() {
        _ = (awsAccessKeyId, awsSecretKey, stripeLive, authHeader, dbUrl,
             slackWebhook, clientSecret, dbPassword, pemKey,
             highEntropyBlob, hardcodedSalt, hardcodedIV)
    }
}
