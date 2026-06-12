//
//  InsecureStorage.swift
//  BadPracticesIPA
//
//  Examples of insecure data persistence: UserDefaults for secrets,
//  plaintext files, plist secrets, world-readable caches.
//

import Foundation

enum InsecureStorage {

    // MARK: - Secrets stored in UserDefaults (BAD)

    static func saveSecretsInUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set("user@example.com", forKey: "user_email")
        defaults.set("PlainTextPassword!2024", forKey: "user_password")
        defaults.set(BadSecrets.productionApiKey, forKey: "api_key")
        defaults.set(BadSecrets.jwtSigningSecret, forKey: "jwt_secret")
        defaults.set(BadSecrets.refreshToken, forKey: "refresh_token")
        defaults.set("4111111111111111", forKey: "credit_card_number")
        defaults.set("123", forKey: "credit_card_cvv")
        defaults.set("12/30", forKey: "credit_card_exp")
        defaults.set("123-45-6789", forKey: "ssn")
        defaults.set(true, forKey: "is_admin")
    }

    static func readSecretsFromUserDefaults() -> [String: Any] {
        let defaults = UserDefaults.standard
        return [
            "user_email": defaults.string(forKey: "user_email") ?? "",
            "user_password": defaults.string(forKey: "user_password") ?? "",
            "api_key": defaults.string(forKey: "api_key") ?? "",
            "jwt_secret": defaults.string(forKey: "jwt_secret") ?? "",
            "credit_card_number": defaults.string(forKey: "credit_card_number") ?? ""
        ]
    }

    // MARK: - Plain text file in Documents/ (BAD: not encrypted, no protection class)

    static func dumpSecretsToDocuments() {
        let payload = """
        # Cacomi insecure dump
        email=user@example.com
        password=PlainTextPassword!2024
        api_key=\(BadSecrets.productionApiKey)
        jwt_secret=\(BadSecrets.jwtSigningSecret)
        stripe_secret=\(BadSecrets.stripeSecretKey)
        db_connection=\(BadSecrets.dbConnectionString)
        """

        guard let documents = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else { return }

        let url = documents.appendingPathComponent("secrets_dump.txt")
        // BAD: no .completeFileProtection, plain text.
        try? payload.write(to: url, atomically: true, encoding: .utf8)
    }

    // MARK: - Caches directory with PII (BAD)

    static func cachePII() {
        let pii: [String: Any] = [
            "full_name": "John Doe",
            "ssn": "123-45-6789",
            "passport": "X12345678",
            "address": "742 Evergreen Terrace, Springfield",
            "phone": "+1-555-FAKE-CACOMI"
        ]
        guard let caches = FileManager.default.urls(
            for: .cachesDirectory, in: .userDomainMask
        ).first else { return }
        let url = caches.appendingPathComponent("user_pii.plist")
        (pii as NSDictionary).write(to: url, atomically: true)
    }

    // MARK: - Tmp directory leak (BAD)

    static func writeTokenToTmp() {
        let tmp = NSTemporaryDirectory() + "session.token"
        try? BadSecrets.refreshToken.write(
            toFile: tmp,
            atomically: true,
            encoding: .utf8
        )
    }

    // MARK: - Keychain misuse: kSecAttrAccessibleAlways (BAD)

    static func storeInKeychainAlwaysAccessible() {
        let value = Data(BadSecrets.productionApiKey.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "production_api_key",
            kSecAttrService as String: "com.cacomi.badpractices",
            // BAD: accessible even when device is locked
            kSecAttrAccessible as String: kSecAttrAccessibleAlways,
            kSecValueData as String: value
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    // MARK: - Load secrets.json from bundle (already shipped in IPA)

    static func loadBundledSecretsJSON() -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: "secrets", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }
        return json
    }

    static func loadBundledSecretsPlist() -> [String: Any] {
        var result: [String: Any] = [:]
        let keys = [
            "CACOMI_FAKE_API_KEY",
            "CACOMI_FAKE_SECRET",
            "FirebaseAPIKey",
            "DebugEndpoint"
        ]
        for key in keys {
            if let value = Bundle.main.object(forInfoDictionaryKey: key) {
                result[key] = value
            }
        }
        return result
    }

    static func runAll() {
        saveSecretsInUserDefaults()
        _ = readSecretsFromUserDefaults()
        dumpSecretsToDocuments()
        cachePII()
        writeTokenToTmp()
        storeInKeychainAlwaysAccessible()
        _ = loadBundledSecretsJSON()
        _ = loadBundledSecretsPlist()
    }
}
