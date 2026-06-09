//
//  WeakCrypto.swift
//  CacomiTestApp
//
//  Fixtures for WeakCipherRule, WeakKeyDerivation, WeakCryptoExtensions.
//

import Foundation
import CommonCrypto
import CryptoKit

enum WeakCryptoCases {

    static let plain = Data("hello".utf8)
    static let keyData = Data(repeating: 0x42, count: 32)
    static let ivData = Data(repeating: 0x00, count: 16)

    // MARK: - DES (broken)
    static func desEncrypt() {
        var out = Data(count: 64)
        var moved = 0
        // CACOMI-EXPECT[WeakCipherRule|high]: DES algorithm is broken
        _ = out.withUnsafeMutableBytes { outBytes in
            plain.withUnsafeBytes { inBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmDES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeDES,
                        nil,
                        inBytes.baseAddress, plain.count,
                        outBytes.baseAddress, outBytes.count,
                        &moved
                    )
                }
            }
        }
    }

    // MARK: - 3DES (deprecated)
    static func tripleDESEncrypt() {
        var out = Data(count: 64)
        var moved = 0
        // CACOMI-EXPECT[WeakCipherRule|high]: 3DES algorithm is deprecated
        _ = out.withUnsafeMutableBytes { outBytes in
            plain.withUnsafeBytes { inBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithm3DES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySize3DES,
                        nil,
                        inBytes.baseAddress, plain.count,
                        outBytes.baseAddress, outBytes.count,
                        &moved
                    )
                }
            }
        }
    }

    // MARK: - RC4 (broken)
    static func rc4Encrypt() {
        var out = Data(count: 64)
        var moved = 0
        // CACOMI-EXPECT[WeakCipherRule|high]: RC4 cipher is broken
        _ = out.withUnsafeMutableBytes { outBytes in
            plain.withUnsafeBytes { inBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmRC4),
                        CCOptions(0),
                        keyBytes.baseAddress, 16,
                        nil,
                        inBytes.baseAddress, plain.count,
                        outBytes.baseAddress, outBytes.count,
                        &moved
                    )
                }
            }
        }
    }

    // MARK: - ECB mode (insecure)
    static func aesECB() {
        var out = Data(count: 64)
        var moved = 0
        // CACOMI-EXPECT[WeakCipherRule|high]: ECB mode is not semantically secure
        _ = out.withUnsafeMutableBytes { outBytes in
            plain.withUnsafeBytes { inBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES256,
                        nil,
                        inBytes.baseAddress, plain.count,
                        outBytes.baseAddress, outBytes.count,
                        &moved
                    )
                }
            }
        }
    }

    // MARK: - Broken hashes via CryptoKit Insecure
    static func md5CryptoKit() -> String {
        // CACOMI-EXPECT[WeakCryptoExtensions|high]: Insecure.MD5 is broken
        let digest = Insecure.MD5.hash(data: plain)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func sha1CryptoKit() -> String {
        // CACOMI-EXPECT[WeakCryptoExtensions|high]: Insecure.SHA1 is broken
        let digest = Insecure.SHA1.hash(data: plain)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - CC_MD5 / CC_SHA1
    static func md5Common() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        plain.withUnsafeBytes { buf in
            // CACOMI-EXPECT[WeakCryptoExtensions|high]: CC_MD5 broken hash
            _ = CC_MD5(buf.baseAddress, CC_LONG(plain.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func sha1Common() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        plain.withUnsafeBytes { buf in
            // CACOMI-EXPECT[WeakCryptoExtensions|high]: CC_SHA1 broken hash
            _ = CC_SHA1(buf.baseAddress, CC_LONG(plain.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Weak PBKDF2 iteration count
    static func weakPBKDF2() -> Data {
        let password = Array("password".utf8)
        let salt = Array("staticsalt".utf8)
        var derived = [UInt8](repeating: 0, count: 32)
        // CACOMI-EXPECT[WeakKeyDerivation|high]: PBKDF2 rounds = 1000 is below safe threshold
        let rounds: UInt32 = 1000
        _ = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            password, password.count,
            salt, salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            rounds,
            &derived, derived.count
        )
        return Data(derived)
    }

    // MARK: - Negative controls
    static func gcmEncrypt() throws -> Data {
        // CACOMI-NEGATIVE[WeakCipherRule]: AES-GCM is authenticated, strong cipher
        let key = SymmetricKey(size: .bits256)
        let sealed = try AES.GCM.seal(plain, using: key)
        return sealed.combined ?? Data()
    }

    static func sha256Hash() -> String {
        // CACOMI-NEGATIVE[WeakCryptoExtensions]: SHA-256 is acceptable
        let digest = SHA256.hash(data: plain)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func runAll() {
        desEncrypt(); tripleDESEncrypt(); rc4Encrypt(); aesECB()
        _ = md5CryptoKit(); _ = sha1CryptoKit(); _ = md5Common(); _ = sha1Common()
        _ = weakPBKDF2(); _ = try? gcmEncrypt(); _ = sha256Hash()
    }
}
