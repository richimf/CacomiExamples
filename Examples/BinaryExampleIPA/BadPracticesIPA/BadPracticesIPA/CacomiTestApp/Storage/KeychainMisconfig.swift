//
//  KeychainMisconfig.swift
//  BadPracticesIPA
//
//  Cacomi fixture: Keychain accessibility misconfigurations (M9 — Insecure Data Storage).
//  All token values are FAKE/dummy — for static-analysis testing only.
//

import Foundation
import Security

enum KeychainMisconfigCases {

    // BAD: kSecAttrAccessibleAlways — item readable on locked device AND in unencrypted backups.
    static func storeSessionTokenAlwaysAccessible() {
        let token = Data("FAKE_SESSION_TOKEN_cacomi_1234567890abcdef".utf8)
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      "session_token",
            kSecAttrService as String:      "com.cacomi.example",
            // CACOMI-EXPECT[MobileMisuse|high]: kSecAttrAccessibleAlways allows keychain read while device is locked and in unencrypted backups (M9)
            kSecAttrAccessible as String:   kSecAttrAccessibleAlways,
            kSecValueData as String:        token
        ]
        SecItemDelete(query as CFDictionary)
        _ = SecItemAdd(query as CFDictionary, nil)
    }

    // BAD: kSecAttrAccessibleAfterFirstUnlock — persists across reboots for background daemons;
    // acceptable only for non-sensitive background data, not for auth tokens.
    static func storeOAuthTokenAfterFirstUnlock() {
        let token = Data("FAKE_OAUTH_TOKEN_cacomi_abcdef1234567890".utf8)
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      "oauth_token",
            kSecAttrService as String:      "com.cacomi.example",
            // CACOMI-EXPECT[MobileMisuse|high]: kSecAttrAccessibleAfterFirstUnlock used for a sensitive OAuth token — accessible by malware after first unlock without requiring re-auth (M9)
            kSecAttrAccessible as String:   kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData as String:        token
        ]
        SecItemDelete(query as CFDictionary)
        _ = SecItemAdd(query as CFDictionary, nil)
    }

    // BAD: kSecAttrAccessibleAlwaysThisDeviceOnly — not backed up, but still readable on a locked device.
    static func storeBiometricBypassTokenAlwaysThisDevice() {
        let token = Data("FAKE_BIOMETRIC_TOKEN_cacomi_deadbeef1234".utf8)
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      "biometric_bypass_token",
            kSecAttrService as String:      "com.cacomi.example",
            // CACOMI-EXPECT[MobileMisuse|high]: kSecAttrAccessibleAlwaysThisDeviceOnly still permits access on a locked device — inappropriate for high-sensitivity auth material (M9)
            kSecAttrAccessible as String:   kSecAttrAccessibleAlwaysThisDeviceOnly,
            kSecValueData as String:        token
        ]
        SecItemDelete(query as CFDictionary)
        _ = SecItemAdd(query as CFDictionary, nil)
    }

    // MARK: - Negative cases

    // GOOD: kSecAttrAccessibleWhenUnlockedThisDeviceOnly — strongest general-purpose protection;
    // item only readable when device is unlocked, never migrated to new device or backup.
    static func storeHighValueTokenSecurely() {
        let token = Data("FAKE_HIGH_VALUE_TOKEN_cacomi_secure".utf8)
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      "high_value_token",
            kSecAttrService as String:      "com.cacomi.example",
            // CACOMI-NEGATIVE[MobileMisuse]: kSecAttrAccessibleWhenUnlockedThisDeviceOnly is the recommended protection class for sensitive tokens
            kSecAttrAccessible as String:   kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecValueData as String:        token
        ]
        SecItemDelete(query as CFDictionary)
        _ = SecItemAdd(query as CFDictionary, nil)
    }

    // GOOD: kSecAttrAccessibleWhenUnlocked — same access window as above but allows iCloud Keychain sync;
    // acceptable when cross-device sync is an explicit product requirement.
    static func storeSyncablePreferenceTokenSecurely() {
        let token = Data("FAKE_SYNCABLE_TOKEN_cacomi_example".utf8)
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      "syncable_preference_token",
            kSecAttrService as String:      "com.cacomi.example",
            // CACOMI-NEGATIVE[MobileMisuse]: kSecAttrAccessibleWhenUnlocked — only readable while device is unlocked; sync is intentional here
            kSecAttrAccessible as String:   kSecAttrAccessibleWhenUnlocked,
            kSecValueData as String:        token
        ]
        SecItemDelete(query as CFDictionary)
        _ = SecItemAdd(query as CFDictionary, nil)
    }
}
