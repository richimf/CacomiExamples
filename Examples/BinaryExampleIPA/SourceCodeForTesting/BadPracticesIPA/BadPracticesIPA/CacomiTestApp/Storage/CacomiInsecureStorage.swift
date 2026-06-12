//
//  InsecureStorage.swift
//  CacomiTestApp
//
//  Fixtures for InsecureStorageRule and MobileMisuse (keychain/IV).
//

import Foundation
import Security

enum InsecureStorageCases {

    static func savePasswordInUserDefaults() {
        let defaults = UserDefaults.standard
        // CACOMI-EXPECT[InsecureStorageRule|high]: password persisted in UserDefaults
        defaults.set("P@ssw0rd!2024", forKey: "user_password")
        // CACOMI-EXPECT[InsecureStorageRule|high]: bearer token persisted in UserDefaults
        defaults.set("eyJhbGciOiJIUzI1NiJ9.abc.def", forKey: "auth_token")
        // CACOMI-EXPECT[InsecureStorageRule|high]: PII (PAN) persisted in UserDefaults
        defaults.set("4111111111111111", forKey: "credit_card_number")
    }

    // CACOMI-EXPECT[MobileMisuse|high]: hardcoded IV used for symmetric encryption
    static let iv = "1234567890123456"

    static func storeInKeychainAlwaysAccessible() {
        let data = Data("super-secret-value".utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "session",
            kSecAttrService as String: "com.cacomi.test",
            // CACOMI-EXPECT[MobileMisuse|high]: keychain item readable even when device locked
            kSecAttrAccessible as String: kSecAttrAccessibleAlways,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func saveUIPreference() {
        // CACOMI-NEGATIVE[InsecureStorageRule]: non-sensitive UI preference in UserDefaults
        UserDefaults.standard.set(true, forKey: "ui_dark_mode_enabled")
    }
}
