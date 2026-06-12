//
//  InsecureRandom.swift
//  BadPracticesIPA
//
//  Cacomi fixture: insecure PRNG usage for security-sensitive values (M5 — Insufficient Cryptography).
//  All derived values are FAKE/dummy — for static-analysis testing only.
//

import Foundation
import Security
import CommonCrypto

enum InsecureRandomCases {

    // BAD: arc4random_uniform used to generate a session token.
    // arc4random is not cryptographically suitable for security tokens.
    static func generateSessionTokenWithArc4() -> String {
        var token = ""
        for _ in 0..<32 {
            // CACOMI-EXPECT[InsecureRandom|high]: arc4random_uniform used to produce security token — not a CSPRNG
            let byte = arc4random_uniform(256)
            token += String(format: "%02x", byte)
        }
        return token
    }

    // BAD: Int.random(in:) (backed by a non-CSPRNG on older runtimes) used to build an IV.
    // Swift's random APIs are NOT guaranteed to be cryptographically secure.
    static func generateIVWithSwiftRandom() -> [UInt8] {
        // CACOMI-EXPECT[InsecureRandom|high]: Int.random(in:) used to construct a cipher IV — use SecRandomCopyBytes instead
        return (0..<16).map { _ in UInt8(Int.random(in: 0...255)) }
    }

    // BAD: arc4random used to generate a salt for password-based key derivation.
    static func generateSaltWithArc4() -> Data {
        var saltBytes = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 {
            // CACOMI-EXPECT[InsecureRandom|high]: arc4random used to build a PBKDF2 salt — replace with SecRandomCopyBytes
            saltBytes[i] = UInt8(arc4random_uniform(256))
        }
        return Data(saltBytes)
    }

    // BAD: hardcoded IV (all-zero bytes) passed directly into AES-CBC encryption.
    // CACOMI-EXPECT[WeakCipherRule|high]: hardcoded all-zero IV makes CBC mode deterministic and breaks semantic security
    static let hardcodedAESIV: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ]

    // BAD: hardcoded salt fed into PBKDF2 key derivation.
    // CACOMI-EXPECT[WeakCipherRule|high]: hardcoded static salt eliminates per-credential uniqueness — all derived keys are identical for the same password
    static let hardcodedPBKDF2Salt: [UInt8] = [
        0xCA, 0xC0, 0x41, 0x11, 0xCA, 0xC0, 0x41, 0x11,
        0xCA, 0xC0, 0x41, 0x11, 0xCA, 0xC0, 0x41, 0x11
    ]

    static func deriveKeyWithHardcodedSalt(password: String) -> Data {
        let pwBytes = Array(password.utf8)
        var derived = [UInt8](repeating: 0, count: 32)
        // CACOMI-EXPECT[WeakCipherRule|high]: PBKDF2 called with hardcoded salt and hardcoded IV — both should be randomly generated per invocation
        _ = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            pwBytes, pwBytes.count,
            hardcodedPBKDF2Salt, hardcodedPBKDF2Salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            10_000,
            &derived, derived.count
        )
        return Data(derived)
    }

    // MARK: - Negative cases

    // GOOD: SecRandomCopyBytes is a CSPRNG backed by the OS entropy pool.
    static func generateTokenSecurely(length: Int = 32) -> Data? {
        var bytes = [UInt8](repeating: 0, count: length)
        // CACOMI-NEGATIVE[InsecureRandom]: SecRandomCopyBytes provides cryptographically secure random bytes
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        guard status == errSecSuccess else { return nil }
        return Data(bytes)
    }

    // GOOD: random IV generated via SecRandomCopyBytes immediately before use.
    static func encryptWithSecureIV(plaintext: Data, key: Data) -> Data? {
        var ivBytes = [UInt8](repeating: 0, count: kCCBlockSizeAES128)
        // CACOMI-NEGATIVE[InsecureRandom]: fresh random IV produced by CSPRNG for every encryption call
        guard SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, &ivBytes) == errSecSuccess else {
            return nil
        }
        // (Encryption body omitted — IV generation is the fixture target.)
        return Data(ivBytes) // placeholder return
    }
}
