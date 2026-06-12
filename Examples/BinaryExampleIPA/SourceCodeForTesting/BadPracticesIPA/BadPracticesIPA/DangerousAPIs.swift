//
//  DangerousAPIs.swift
//  BadPracticesIPA
//
//  Anti-patterns: insecure deserialization, path traversal,
//  jailbreak-detection bypass, debug flags, reflection-based
//  selector dispatch and other APIs flagged by mobile scanners.
//

import Foundation
import UIKit

enum DangerousAPIs {

    // MARK: - Insecure deserialization (BAD)

    static func insecureUnarchive(from data: Data) -> Any? {
        // BAD: NSKeyedUnarchiver without secure coding allows arbitrary
        // class instantiation -> RCE-style gadget chains.
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }

    static func insecureUnarchiveFromFile(_ path: String) -> Any? {
        // BAD: same issue, reads from a file path that could be controlled.
        return NSKeyedUnarchiver.unarchiveObject(withFile: path)
    }

    // MARK: - Path traversal (BAD)

    static func readUserSuppliedFile(_ relative: String) -> String? {
        // BAD: no canonicalization, attacker can supply "../../etc/passwd"
        guard let docs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else { return nil }
        let url = docs.appendingPathComponent(relative)
        return try? String(contentsOf: url, encoding: .utf8)
    }

    // MARK: - Jailbreak detection bypass / disabled (BAD)

    static func isDeviceJailbroken() -> Bool {
        // BAD: stub that always returns false -> bypasses any detection
        return false
    }

    static let debugMenuEnabled = true
    static let allowSelfSignedCerts = true
    static let skipCertPinning = true
    static let logVerbose = true

    // MARK: - Selector-based reflection (BAD: dynamic dispatch on untrusted input)

    static func invokeArbitrarySelector(target: NSObject, name: String) {
        let sel = NSSelectorFromString(name)
        if target.responds(to: sel) {
            // BAD: invoking selector built from untrusted input
            _ = target.perform(sel)
        }
    }

    // MARK: - Dangerous URL handling (BAD)

    static func openAnyURL(_ string: String) {
        // BAD: no validation of scheme or host
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Disabled SSL hostname verification flag (BAD, looks-like-config)

    static let SSL_VERIFY_HOST = false
    static let SSL_VERIFY_PEER = false
    static let TLS_INSECURE_SKIP_VERIFY = true

    // MARK: - Hardcoded credentials matching common scanner regex

    // Looks-like-AWS pattern: AKIA[0-9A-Z]{16}
    static let awsLooksLike   = "AKIAJSIE27KKMHXI3BJQ"
    // Looks-like-Google API key: AIza[0-9A-Za-z\-_]{35}
    static let googleLooksLike = "AIzaSyDuLooksLikeRealGoogleKeyOnlyForScanner"
    // Looks-like-Slack: xox[abp]-...
    static let slackLooksLike = "xoxp-1234567890-1234567890-1234567890-abcdefghijklmnop"
    // JWT looking string: eyJ...
    static let jwtLooksLike   = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NSIsIm5hbWUiOiJhZG1pbiJ9.FAKE_SIGNATURE_CACOMI_jwt_token"
    // GitHub fine-grained PAT: github_pat_...
    static let githubFineGrained = "github_pat_FAKECACOMI11AAAAAAAAA0_FAKECACOMIfinegrainedTokenABCDEFGHIJKLMNOPQRSTUVWXYZ1234"
    // Square access token
    static let squareAccessToken = "sq0atp-FAKECACOMIsquareAccessToken123"
    // Square OAuth secret
    static let squareOAuthSecret = "sq0csp-FAKECACOMIsquareOAuthSecret123456789012345"
    // PayPal Braintree access token
    static let braintreeToken = "access_token$production$abcdefghijklmnop$1234567890abcdef1234567890abcdef"
    // Discord Bot token
    static let discordBotToken = "FAKECACOMIdiscordBotTokenMTAxMjM0NTY3ODkw.FAKE.XXXXXXXXXXXXXXXXXXXXXXXXXXX"
    // NPM auth token
    static let npmToken = "npm_FAKECACOMInpmTokenABCDEFGHIJ1234567890abcdef"

    static func runAll() {
        _ = insecureUnarchive(from: Data())
        _ = readUserSuppliedFile("../../etc/passwd")
        _ = isDeviceJailbroken()
        openAnyURL("javascript:alert(1)")
        openAnyURL("file:///etc/passwd")
    }
}
