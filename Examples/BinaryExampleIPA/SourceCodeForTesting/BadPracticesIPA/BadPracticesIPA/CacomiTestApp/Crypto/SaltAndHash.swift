//
//  SaltAndHash.swift
//  CacomiTestApp
//
//  Fixtures for SaltHashRule.
//

import Foundation
import CommonCrypto
import CryptoKit
import Security

enum SaltAndHash {

    // CACOMI-EXPECT[SaltHashRule|high]: hardcoded static salt
    static let staticSalt = "staticsalt123"

    static func hashWithoutSalt(_ password: String) -> String {
        let data = Data(password.utf8)
        // CACOMI-EXPECT[SaltHashRule|high]: password hashed without any salt
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func hashWithStaticSalt(_ password: String) -> String {
        // CACOMI-EXPECT[SaltHashRule|high]: password mixed with a hardcoded salt
        let data = Data((staticSalt + password).utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // CACOMI-NEGATIVE[SaltHashRule]: PBKDF2 with secure random salt and high rounds
    static func hashWithRandomSaltPBKDF2(_ password: String) -> (salt: Data, derived: Data)? {
        var saltBytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, saltBytes.count, &saltBytes)
        guard status == errSecSuccess else { return nil }
        let pw = Array(password.utf8)
        var derived = [UInt8](repeating: 0, count: 32)
        _ = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            pw, pw.count,
            saltBytes, saltBytes.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            200_000,
            &derived, derived.count
        )
        return (Data(saltBytes), Data(derived))
    }
}
