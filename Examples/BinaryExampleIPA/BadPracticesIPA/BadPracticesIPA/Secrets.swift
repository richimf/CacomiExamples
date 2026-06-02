//
//  Secrets.swift
//  BadPracticesIPA
//
//  Created by Ricardo Montesinos on 02/06/26.
//
import Foundation

enum BadSecrets {
    // MARK: - Fake hardcoded API keys
    static let unused_api_key = "sk_test_FAKE_CACOMI_1234567890abcdef"
    static let unused_secret_key = "SECRET_FAKE_CACOMI_0987654321"
    static let unused_bearer_token = "Bearer FAKE_CACOMI_TOKEN_abcdefghijklmnopqrstuvwxyz"
    static let unused_firebase_key = "AIzaSyFAKE_CACOMI_TEST_KEY_123456789"
    static let unused_aws_access_key = "AKIAFAKECACOMI123456"
    static let unused_aws_secret = "FAKEwJalrXUtnFEMI/K7MDENG/bPxRfiCYFAKEKEY"
    static let unused_private_key = """
    -----BEGIN PRIVATE KEY-----
    FAKECACOMIKEY1234567890
    -----END PRIVATE KEY-----
    """

    // MARK: - Used values to force them into the binary

    static let productionApiURL = "https://api.fake-production-cacomi.com/v1"
    static let productionApiKey = "prod_FAKE_CACOMI_API_KEY_DO_NOT_USE"
    static let sentryDSN = "https://fakepublickey@o0.ingest.sentry.io/123456"

    static func buildUnsafeHeaders() -> [String: String] {
        [
            "Authorization": "Bearer \(productionApiKey)",
            "X-API-Key": productionApiKey,
            "X-Internal-Secret": "internal_secret_FAKE_CACOMI_123"
        ]
    }

    static func printBadLogs() {
        print("Login token: \(productionApiKey)")
        debugPrint("Authorization header:", buildUnsafeHeaders())
        NSLog("User password is: FAKE_PASSWORD_123456")
    }
}
