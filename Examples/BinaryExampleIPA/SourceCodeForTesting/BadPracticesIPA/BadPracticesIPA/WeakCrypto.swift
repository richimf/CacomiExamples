//
//  WeakCrypto.swift
//  BadPracticesIPA
//
//  Examples of WEAK / BROKEN cryptography to be detected by scanners.
//  DO NOT use any of this code in real products.
//

import Foundation
import CommonCrypto

enum WeakCrypto {

    // MARK: - Hardcoded symmetric keys / IVs (anti-pattern)

    static let hardcodedAESKey = "1234567890ABCDEF1234567890ABCDEF" // 32 bytes "key"
    static let hardcodedIV = "0000000000000000"                    // static IV
    static let hardcodedDESKey = "weakdes!"                        // 8 bytes
    static let hardcodedSalt = "saltysalt"                         // static salt

    // MARK: - Broken hash algorithms

    static func md5(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func sha1(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_SHA1(buffer.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Hash passwords with MD5 (insecure)

    static func hashPassword(_ password: String) -> String {
        // BAD: unsalted MD5 of password.
        return md5(password)
    }

    static func hashPasswordWithStaticSalt(_ password: String) -> String {
        // BAD: static, hardcoded salt + SHA1.
        return sha1(hardcodedSalt + password)
    }

    // MARK: - AES in ECB mode (insecure)

    static func aesECBEncrypt(_ plaintext: String) -> Data? {
        let keyData = Data(hardcodedAESKey.utf8)
        let dataIn = Data(plaintext.utf8)
        let bufferSize = dataIn.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesEncrypted = 0

        let status = buffer.withUnsafeMutableBytes { bufferBytes -> CCCryptorStatus in
            dataIn.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        // BAD: ECB mode is not semantically secure
                        CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES256,
                        nil,
                        dataBytes.baseAddress, dataIn.count,
                        bufferBytes.baseAddress, bufferSize,
                        &numBytesEncrypted
                    )
                }
            }
        }
        guard status == kCCSuccess else { return nil }
        buffer.removeSubrange(numBytesEncrypted..<buffer.count)
        return buffer
    }

    // MARK: - AES-CBC with static IV (insecure)

    static func aesCBCEncrypt(_ plaintext: String) -> Data? {
        let keyData = Data(hardcodedAESKey.utf8)
        let ivData = Data(hardcodedIV.utf8) // BAD: static IV reused
        let dataIn = Data(plaintext.utf8)
        let bufferSize = dataIn.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesEncrypted = 0

        let status = buffer.withUnsafeMutableBytes { bufferBytes -> CCCryptorStatus in
            dataIn.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    ivData.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, kCCKeySizeAES256,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, dataIn.count,
                            bufferBytes.baseAddress, bufferSize,
                            &numBytesEncrypted
                        )
                    }
                }
            }
        }
        guard status == kCCSuccess else { return nil }
        buffer.removeSubrange(numBytesEncrypted..<buffer.count)
        return buffer
    }

    // MARK: - DES / 3DES (broken / deprecated)

    static func desEncrypt(_ plaintext: String) -> Data? {
        let keyData = Data(hardcodedDESKey.utf8)
        let dataIn = Data(plaintext.utf8)
        let bufferSize = dataIn.count + kCCBlockSizeDES
        var buffer = Data(count: bufferSize)
        var numBytesEncrypted = 0

        let status = buffer.withUnsafeMutableBytes { bufferBytes -> CCCryptorStatus in
            dataIn.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmDES), // BAD: DES is broken
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                        keyBytes.baseAddress, kCCKeySizeDES,
                        nil,
                        dataBytes.baseAddress, dataIn.count,
                        bufferBytes.baseAddress, bufferSize,
                        &numBytesEncrypted
                    )
                }
            }
        }
        guard status == kCCSuccess else { return nil }
        buffer.removeSubrange(numBytesEncrypted..<buffer.count)
        return buffer
    }

    // MARK: - Insecure RNG / predictable seeds

    static func predictableToken() -> String {
        // BAD: using system rand() and seeding with time gives predictable values
        srand48(Int(Date().timeIntervalSince1970))
        let value = Int(drand48() * 1_000_000)
        return "TOKEN_\(value)"
    }

    static func weakSessionId() -> String {
        // BAD: arc4random_uniform with tiny range as session ID
        let n = arc4random_uniform(10_000)
        return "SESSION_\(n)"
    }

    // MARK: - Custom "encryption" via XOR (snake-oil crypto)

    static func xorEncrypt(_ plaintext: String, key: String = "cacomi") -> Data {
        let bytes = Array(plaintext.utf8)
        let keyBytes = Array(key.utf8)
        var out = [UInt8]()
        for (i, b) in bytes.enumerated() {
            out.append(b ^ keyBytes[i % keyBytes.count])
        }
        return Data(out)
    }

    // MARK: - Base64 mis-used as "encryption"

    static func obfuscate(_ secret: String) -> String {
        // BAD: base64 is NOT encryption
        return Data(secret.utf8).base64EncodedString()
    }

    static func runAll() {
        _ = md5("admin123")
        _ = sha1("admin123")
        _ = hashPassword("password")
        _ = hashPasswordWithStaticSalt("password")
        _ = aesECBEncrypt("super secret data")
        _ = aesCBCEncrypt("super secret data")
        _ = desEncrypt("super secret data")
        _ = predictableToken()
        _ = weakSessionId()
        _ = xorEncrypt(BadSecrets.productionApiKey)
        _ = obfuscate(BadSecrets.jwtSigningSecret)
    }
}
