//
//  JWTCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: JWTWeakSecret / JWTValidation.
//

import Foundation

enum JWTCacomi {

    // BAD: hardcoded weak HS256 secret                   // CACOMI-EXPECT: JWTWeakSecret
    static let jwtSecret = "changeme"

    static let staticAdminToken = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiYWRtaW4ifQ.dummySig"
    static let noneAlgToken     = "eyJhbGciOiJub25lIn0.eyJyb2xlIjoiYWRtaW4ifQ."

    static func validate(_ token: String, secret: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count >= 2 else { return false }

        if let h = b64decode(String(parts[0])),
           let header = try? JSONSerialization.jsonObject(with: h) as? [String: Any],
           let alg = header["alg"] as? String,
           alg.lowercased() == "none" {
            // BAD: accepts alg "none"                      // CACOMI-EXPECT: JWTValidation
            return true
        }

        if parts.count == 3 {
            let expected = "fakeSigOf\(secret)"
            // BAD: == is not constant-time                 // CACOMI-EXPECT: JWTValidation
            return String(parts[2]) == expected
        }
        return false
    }

    static func decodeWithoutVerify(_ token: String) -> [String: Any]? {
        // BAD: payload decoded without signature check      // CACOMI-EXPECT: JWTValidation
        let parts = token.split(separator: ".")
        guard parts.count >= 2, let p = b64decode(String(parts[1])) else { return nil }
        return try? JSONSerialization.jsonObject(with: p) as? [String: Any]
    }

    private static func b64decode(_ s: String) -> Data? {
        var b = s.replacingOccurrences(of: "-", with: "+")
                 .replacingOccurrences(of: "_", with: "/")
        while b.count % 4 != 0 { b += "=" }
        return Data(base64Encoded: b)
    }
}
