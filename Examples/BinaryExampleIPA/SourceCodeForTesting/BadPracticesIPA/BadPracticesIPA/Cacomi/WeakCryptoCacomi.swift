//
//  WeakCryptoCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: WeakCipher / WeakKeyDerivation / WeakCryptoExtensions.
//

import Foundation
import CommonCrypto
import CryptoKit

enum WeakCryptoCacomi {

    static let plain = Data("hello".utf8)
    static let key = Data(repeating: 0x42, count: 32)

    static func md5UsedForSecurity(_ s: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        let data = Data(s.utf8)
        data.withUnsafeBytes { b in
            // BAD: MD5 used for "security"                // CACOMI-EXPECT: WeakCryptoExtensions
            _ = CC_MD5(b.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func sha1AsAuthHash(_ s: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let data = Data(s.utf8)
        data.withUnsafeBytes { b in
            // BAD: SHA1 used in security context           // CACOMI-EXPECT: WeakCryptoExtensions
            _ = CC_SHA1(b.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func desEncrypt() -> Data {
        var out = Data(count: 64); var moved = 0
        // BAD: DES is broken                               // CACOMI-EXPECT: WeakCipher
        _ = out.withUnsafeMutableBytes { o in
            plain.withUnsafeBytes { i in
                key.withUnsafeBytes { k in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmDES),
                            CCOptions(kCCOptionPKCS7Padding),
                            k.baseAddress, kCCKeySizeDES, nil,
                            i.baseAddress, plain.count,
                            o.baseAddress, o.count, &moved)
                }
            }
        }
        return out
    }

    static func tripleDESEncrypt() -> Data {
        var out = Data(count: 64); var moved = 0
        // BAD: 3DES is deprecated                          // CACOMI-EXPECT: WeakCipher
        _ = out.withUnsafeMutableBytes { o in
            plain.withUnsafeBytes { i in
                key.withUnsafeBytes { k in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithm3DES),
                            CCOptions(kCCOptionPKCS7Padding),
                            k.baseAddress, kCCKeySize3DES, nil,
                            i.baseAddress, plain.count,
                            o.baseAddress, o.count, &moved)
                }
            }
        }
        return out
    }

    static func aesECBEncrypt() -> Data {
        var out = Data(count: 64); var moved = 0
        // BAD: ECB mode reveals plaintext patterns         // CACOMI-EXPECT: WeakCipher
        _ = out.withUnsafeMutableBytes { o in
            plain.withUnsafeBytes { i in
                key.withUnsafeBytes { k in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                            k.baseAddress, kCCKeySizeAES256, nil,
                            i.baseAddress, plain.count,
                            o.baseAddress, o.count, &moved)
                }
            }
        }
        return out
    }

    static func pbkdf2LowRounds() -> Data {
        let pw = Array("password".utf8)
        let salt = Array("cacomi_static_salt".utf8)
        var out = [UInt8](repeating: 0, count: 32)
        // BAD: PBKDF2 with 1000 rounds is below safe       // CACOMI-EXPECT: WeakKeyDerivation
        let rounds: UInt32 = 1000
        _ = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                 pw, pw.count, salt, salt.count,
                                 CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                 rounds, &out, out.count)
        return Data(out)
    }

    static func insecureOTP() -> String {
        // BAD: arc4random_uniform as token source           // CACOMI-EXPECT: WeakCryptoRNG
        let n = arc4random_uniform(1_000_000)
        return String(format: "%06u", n)
    }

    // GOOD: SHA-256 only as a non-security checksum         // CACOMI-EXPECT: none
    static func contentChecksum(_ data: Data) -> String {
        let d = SHA256.hash(data: data)
        return d.map { String(format: "%02x", $0) }.joined()
    }
}
