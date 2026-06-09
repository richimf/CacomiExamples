//
//  LoginManager.swift
//  BadPracticesIPA
//
//  BAD PRACTICE SIMULATION:
//  Stores the user's password in UserDefaults in plain text and
//  exposes a number of additional anti-patterns that static
//  vulnerability scanners (MobSF, Cacomi, semgrep, gitleaks, etc.)
//  should detect via well-known regex signatures.
//

import Foundation
import CommonCrypto

enum LoginManager {

    private enum Keys {
        static let username     = "saved_username"
        static let password     = "saved_password"
        static let pin          = "saved_pin"
        static let creditCard   = "saved_credit_card"
        static let rememberMe   = "remember_me"
        static let lastLoginAt  = "last_login_at"
        static let sessionToken = "session_token"
    }

    // MARK: - Detectable hardcoded credentials (regex friendly)

    static let hardcodedUsername = "admin"
    static let hardcodedPassword = "P@ssw0rd123!"
    static let backupPassword    = "Welcome1!"
    static let masterKey         = "MASTER_KEY_DO_NOT_COMMIT_abcdef1234567890"

    // Common scanner regex matches:
    static let awsAccessKeyId     = "AKIAIOSFODNN7EXAMPLE"
    static let awsSecretAccessKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    static let googleApiKey       = "AIzaSyD-FAKE-CACOMI-LOGIN-googleApiKey-1234"
    static let githubToken        = "ghp_FAKECACOMILOGIN1234567890abcdefghij12"
    static let stripeLiveKey      = "sk_live_FAKECACOMILOGINstripeLIVE1234567890"
    static let slackBotToken      = "xoxb-1111111111-2222222222-FAKECACOMILoginToken1234"
    static let herokuApiKey       = "heroku_api_key=12345678-aaaa-bbbb-cccc-1234567890ab"
    static let azureSubscription  = "azure_subscription_id=11111111-2222-3333-4444-555555555555"
    static let dockerHubPassword  = "DOCKER_HUB_PASSWORD=FakeCacomiDockerPass2024!"

    // MARK: - Save credentials (BAD)

    static func saveCredentials(username: String, password: String) {
        let defaults = UserDefaults.standard
        // BAD: writing the plaintext password directly to UserDefaults.
        defaults.set(username, forKey: Keys.username)
        defaults.set(password, forKey: Keys.password)
        defaults.set("1234", forKey: Keys.pin)                       // BAD: PIN in plaintext
        defaults.set("4111-1111-1111-1111", forKey: Keys.creditCard) // BAD: PAN in plaintext
        defaults.set(true, forKey: Keys.rememberMe)
        defaults.set(Date(), forKey: Keys.lastLoginAt)

        // BAD: MD5 of password used as session token (broken hash).
        defaults.set(md5(password), forKey: Keys.sessionToken)

        // BAD: logging the password to the console.
        print("[LoginManager] Saved credentials: \(username) / \(password)")
        NSLog("[LoginManager] Persisted password for %@: %@", username, password)
        debugPrint("[LoginManager] PIN:", "1234", "CC:", "4111-1111-1111-1111")
    }

    // MARK: - Load credentials (BAD)

    static func loadSavedPassword() -> String? {
        // BAD: reading a plaintext password from UserDefaults.
        return UserDefaults.standard.string(forKey: Keys.password)
    }

    static func loadSavedUsername() -> String? {
        return UserDefaults.standard.string(forKey: Keys.username)
    }

    // MARK: - Auto-login flow (BAD)

    static func autoLogin() {
        guard
            let username = loadSavedUsername(),
            let password = loadSavedPassword()
        else { return }

        // BAD: sending plaintext credentials over an http:// endpoint.
        print("[LoginManager] Auto-login as \(username) with password \(password)")
        InsecureNetworking.shared.performLogin(user: username, password: password)
    }

    // MARK: - Hardcoded auth "backdoor" check (BAD)

    static func isAdmin(user: String, password: String) -> Bool {
        // BAD: bypass via hardcoded master credentials.
        if user == hardcodedUsername && password == hardcodedPassword { return true }
        if user == "root" && password == "toor" { return true }
        if password == masterKey { return true }
        return false
    }

    // MARK: - Weak password validation (BAD)

    static func isPasswordValid(_ pwd: String) -> Bool {
        // BAD: only checks length, no complexity.
        return pwd.count >= 4
    }

    // MARK: - MD5 helper (broken hash)

    private static func md5(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Simulated entry point

    static func simulate() {
        saveCredentials(
            username: "ricardo@example.com",
            password: "SuperSecret123!"
        )
        _ = loadSavedPassword()
        _ = isAdmin(user: hardcodedUsername, password: hardcodedPassword)
        _ = isPasswordValid("1234")
        autoLogin()
    }
}
