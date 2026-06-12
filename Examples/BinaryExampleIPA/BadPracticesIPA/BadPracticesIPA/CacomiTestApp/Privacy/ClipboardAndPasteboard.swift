//
//  ClipboardAndPasteboard.swift
//  BadPracticesIPA
//
//  Cacomi fixture: sensitive data written to UIPasteboard (M6 — Insecure Data Storage / Privacy).
//  All token values are FAKE/dummy — for static-analysis testing only.
//

import UIKit

enum ClipboardAndPasteboardCases {

    // BAD: auth token written to the system pasteboard.
    // Any app with pasteboard entitlement or universal clipboard enabled can read it.
    static func copyAuthTokenToClipboard(token: String) {
        // CACOMI-EXPECT[PrivacyRule|high]: sensitive auth token written to UIPasteboard.general — accessible to all apps on device and via Universal Clipboard on macOS
        UIPasteboard.general.string = token
    }

    // BAD: password written to the system pasteboard on "copy password" action.
    static func copyPasswordToClipboard(password: String) {
        // CACOMI-EXPECT[PrivacyRule|high]: plaintext password placed on UIPasteboard.general — persists until overwritten and may sync to other devices
        UIPasteboard.general.string = password
    }

    // BAD: session cookie string written to clipboard as a convenience feature.
    static func copySessionCookieToClipboard() {
        let fakeCookie = "session=FAKE_CACOMI_SESSION_COOKIE_abcdef1234567890; Path=/; HttpOnly"
        // CACOMI-EXPECT[PrivacyRule|high]: HTTP session cookie written to UIPasteboard.general — leaks authenticated session identifier
        UIPasteboard.general.string = fakeCookie
    }

    // BAD: credit card PAN written to pasteboard via "copy card number" UI action.
    static func copyCardNumberToClipboard(pan: String) {
        // CACOMI-EXPECT[PrivacyRule|high]: payment card number (PAN) placed on UIPasteboard.general — violates PCI-DSS data handling requirements
        UIPasteboard.general.string = pan
    }

    // BAD: private key PEM block placed on pasteboard for "easy sharing".
    static func copyPrivateKeyToClipboard() {
        let fakePem = """
        -----BEGIN RSA PRIVATE KEY-----
        FAKECACOMIPRIVATEKEYCLIPBOARD1234567890abcdefghijklmnopqrstuvwxyz
        -----END RSA PRIVATE KEY-----
        """
        // CACOMI-EXPECT[PrivacyRule|critical]: RSA private key material written to system pasteboard — catastrophic key exposure
        UIPasteboard.general.string = fakePem
    }

    // BAD: reading back whatever is on the clipboard and logging it — exfiltration vector.
    static func logCurrentClipboard() {
        // CACOMI-EXPECT[PrivacyRule|high]: app reads UIPasteboard.general without user interaction — silent clipboard surveillance
        if let contents = UIPasteboard.general.string {
            // CACOMI-EXPECT[LogParser|high]: clipboard contents (potentially sensitive) dumped to log
            print("[DEBUG] clipboard contents: \(contents)")
        }
    }

    // MARK: - Negative cases

    // GOOD: non-sensitive, user-initiated "Share URL" action — URL is public content.
    static func copyShareURLToClipboard(url: URL) {
        // CACOMI-NEGATIVE[PrivacyRule]: public share URL placed on pasteboard — no sensitive data
        UIPasteboard.general.string = url.absoluteString
    }

    // GOOD: named pasteboard scoped to the app group — not accessible system-wide.
    static func copyToPrivatePasteboard(text: String) {
        // CACOMI-NEGATIVE[PrivacyRule]: named pasteboard limits data to apps sharing the same app group
        let privatePasteboard = UIPasteboard(name: UIPasteboard.Name("com.cacomi.example.internal"), create: true)
        privatePasteboard?.string = text
    }

    // GOOD: non-sensitive display label copied on user tap (e.g. a product name).
    static func copyProductNameToClipboard(name: String) {
        // CACOMI-NEGATIVE[PrivacyRule]: product name is non-sensitive public text
        UIPasteboard.general.string = name
    }
}
