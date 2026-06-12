//
//  JWTHandling.swift
//  CacomiTestApp
//
//  Fixtures for JWTValidationRule and JWTWeakSecretRule.
//

import Foundation

enum JWTHandling {

    // CACOMI-EXPECT[JWTWeakSecretRule|high]: hardcoded weak HS256 secret
    static let jwtSecret = "secret"

    // CACOMI-EXPECT[JWTWeakSecretRule|high]: hardcoded JWT signing secret
    static let signingKey = "cacomi-default-jwt-secret"

    static func validateAcceptingNone(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count >= 2,
              let headerData = decodeBase64(String(parts[0])),
              let header = try? JSONSerialization.jsonObject(with: headerData) as? [String: Any],
              let alg = header["alg"] as? String else { return false }
        // CACOMI-EXPECT[JWTValidationRule|critical]: alg "none" accepted as valid signature
        if alg.lowercased() == "none" { return true }
        return false
    }

    static func decodePayloadWithoutVerify(_ token: String) -> [String: Any]? {
        // CACOMI-EXPECT[JWTValidationRule|high]: payload decoded without verifying signature
        let parts = token.split(separator: ".")
        guard parts.count >= 2,
              let payloadData = decodeBase64(String(parts[1])) else { return nil }
        return try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any]
    }

    static func verifyDisabledFlag(_ token: String) -> Bool {
        // CACOMI-EXPECT[JWTValidationRule|critical]: signature verification disabled by flag
        let verify = false
        if !verify { return true }
        return token.split(separator: ".").count == 3
    }

    private static func decodeBase64(_ s: String) -> Data? {
        var b = s.replacingOccurrences(of: "-", with: "+")
                 .replacingOccurrences(of: "_", with: "/")
        while b.count % 4 != 0 { b += "=" }
        return Data(base64Encoded: b)
    }
}
