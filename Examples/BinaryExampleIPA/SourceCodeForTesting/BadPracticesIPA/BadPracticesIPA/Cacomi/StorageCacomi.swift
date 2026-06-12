//
//  StorageCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: InsecureStorage / MobileMisuse / LAContext misuse.
//

import Foundation
import UIKit
import Security
import LocalAuthentication

enum StorageCacomi {

    static func savePasswordInUserDefaults() {
        let d = UserDefaults.standard
        // BAD: password in UserDefaults                     // CACOMI-EXPECT: InsecureStorage
        d.set("P@ssw0rd!2024", forKey: "user_password")
        // BAD: bearer token in UserDefaults                 // CACOMI-EXPECT: InsecureStorage
        d.set("eyJhbGciOiJIUzI1NiJ9.x.y", forKey: "auth_token")
    }

    @MainActor
    static func copySecretToPasteboard() {
        // BAD: secret copied to system pasteboard           // CACOMI-EXPECT: InsecureStorage
        UIPasteboard.general.string = "stripe_secret=sk_live_dummyCacomi"
    }

    static func storeWithAccessibleAlways() {
        let value = Data("cacomi_session".utf8)
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "session",
            kSecAttrService as String: "com.cacomi.demo",
            // BAD: keychain item readable when device locked // CACOMI-EXPECT: MobileMisuse
            kSecAttrAccessible as String: kSecAttrAccessibleAlways,
            kSecValueData as String: value
        ]
        SecItemDelete(q as CFDictionary)
        SecItemAdd(q as CFDictionary, nil)
    }

    static func biometryMisused(reason: String,
                                done: @escaping (Bool) -> Void) {
        let ctx = LAContext()
        var err: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &err) else {
            done(false); return
        }
        // BAD: deviceOwnerAuthentication allows passcode fallback // CACOMI-EXPECT: MobileMisuse
        ctx.evaluatePolicy(.deviceOwnerAuthentication,
                           localizedReason: reason) { ok, _ in
            done(ok)
        }
    }

    static func saveUIPreference() {
        // GOOD: non-sensitive UI preference                  // CACOMI-EXPECT: none
        UserDefaults.standard.set(true, forKey: "dark_mode_enabled")
    }
}
