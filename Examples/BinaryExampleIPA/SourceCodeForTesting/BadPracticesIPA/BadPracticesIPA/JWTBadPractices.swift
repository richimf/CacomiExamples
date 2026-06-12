//
//  JWTBadPractices.swift
//  BadPracticesIPA
//
//  Examples of bad JWT usage: alg:none acceptance, weak HS256 secrets,
//  hardcoded tokens, no expiration validation, etc.
//

import Foundation

enum JWTBadPractices {

    // MARK: - Hardcoded JWT tokens (detectable)

    static let staticAdminJWT = """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwibmFtZSI6IkNhY29taSBBZG1pbiIsImlhdCI6MTUxNjIzOTAyMn0.FAKECACOMISIGNATUREadminTokenAbCdEf0123456789
    """

    static let staticUserJWT = """
    eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJzdWIiOiIyIiwicm9sZSI6InVzZXIifQ.
    """

    static let hardcodedRefreshJWT = """
    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImNhY29taS1zaWduaW5nLWtleSJ9.eyJzdWIiOiJyaWNoaW1mQGV4YW1wbGUuY29tIiwiZXhwIjo5OTk5OTk5OTk5fQ.FAKECACOMI_RSA_signature_for_refresh_token_AbCdEf0123456789
    """

    // MARK: - Weak HS256 signing secrets

    static let weakHS256Secrets = [
        "secret",
        "password",
        "1234",
        "changeme",
        "jwt_secret",
        "your-256-bit-secret",
        "cacomi-default-jwt-secret"
    ]

    // MARK: - Insecure validation (BAD)

    static func decodeWithoutVerification(_ token: String) -> [String: Any]? {
        // BAD: decoding payload without verifying signature
        let parts = token.split(separator: ".")
        guard parts.count >= 2 else { return nil }
        var b64 = String(parts[1])
        // pad
        while b64.count % 4 != 0 { b64 += "=" }
        guard let data = Data(base64Encoded: b64) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    static func validate(token: String, secret: String) -> Bool {
        // BAD: accepts alg:none
        let parts = token.split(separator: ".")
        guard parts.count >= 2 else { return false }
        if let headerData = Data(base64Encoded: String(parts[0])
                                    .padding(toLength: ((parts[0].count + 3) / 4) * 4,
                                             withPad: "=",
                                             startingAt: 0)),
           let header = try? JSONSerialization.jsonObject(with: headerData) as? [String: Any],
           let alg = header["alg"] as? String,
           alg.lowercased() == "none" {
            // BAD: alg:none accepted as valid
            return true
        }
        // BAD: signature compared with == (not constant-time)
        let expected = "fake_signature_for_\(secret)"
        return parts.count == 3 && String(parts[2]) == expected
    }

    static func simulate() {
        _ = decodeWithoutVerification(staticAdminJWT)
        _ = validate(token: staticUserJWT, secret: weakHS256Secrets.first ?? "secret")
        _ = validate(token: hardcodedRefreshJWT, secret: BadSecrets.jwtSigningSecret)
    }
}
