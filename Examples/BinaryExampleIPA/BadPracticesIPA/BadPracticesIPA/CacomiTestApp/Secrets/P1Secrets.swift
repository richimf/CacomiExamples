//
//  P1Secrets.swift
//  CacomiTestApp
//
//  P1 parity additions for SecretPatternRule / OAuth detection.
//  Mirrors ValidationFixtures/apple/SecretsAuth.swift new patterns.
//  ALL VALUES ARE FAKE / NON-FUNCTIONAL — intentional bad practice for testing only.
//

import Foundation

enum P1Secrets {

    // ── New hardcoded-secret patterns (M1) ──────────────────────────────────

    // CACOMI-EXPECT[SecretPatternRule|high]: Azure AD client secret
    static let azureClientSecret = "Qj8Q~aB3cDeFgHiJkLmNoPqRsTuVwXyZ012345"

    // CACOMI-EXPECT[SecretPatternRule|high]: Supabase project URL
    static let supabaseURL = "https://abcdefghijklmnopqrst.supabase.co"

    // CACOMI-EXPECT[SecretPatternRule|high]: GitLab runner authentication token
    static let gitlabRunner = "glrt-AbCdEfGhIjKlMnOpQrS1"

    // CACOMI-EXPECT[SecretPatternRule|high]: HTTP Basic-auth credentials embedded in URL
    static let basicAuthURL = "https://admin:s3cr3tP4ssw0rd@internal.example.com/api"

    // CACOMI-EXPECT[SecretPatternRule|high]: SMTP credentials embedded in URL
    static let smtpURL = "smtp://mailer:Pa55w0rdMailer@smtp.example.com:587"

    // CACOMI-EXPECT[SecretPatternRule|high]: Twilio account SID + auth token pair
    static let twilioSid = "AC0123456789abcdef0123456789abcdef"
    static let twilioToken = "fakeCacomiTwilioAuthToken0123456789ab"

    // CACOMI-EXPECT[SecretPatternRule|high]: SendGrid API key
    static let sendgrid = "SG.FAKEcacomiSendGridKeyAAAAAAAAAA.BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"

    // CACOMI-EXPECT[SecretPatternRule|low]: PEM certificate block (public cert, informational)
    static let pemCertificate = """
    -----BEGIN CERTIFICATE-----
    MIIBkTCB+wIJAKh3cacomiVALIDATIONfixtureNOTrealCERTdataxxxxxxxx0000
    -----END CERTIFICATE-----
    """

    // ── OAuth misuse (M3) ───────────────────────────────────────────────────

    // CACOMI-EXPECT[SecretPatternRule|high]: OAuth client_secret embedded in app
    static let oauthClientSecret = "abc123def456ghi789jkl012mno345"

    // CACOMI-EXPECT[SecretPatternRule|high]: OAuth implicit flow (response_type=token)
    static let implicitAuthURL =
        "https://idp.example.com/authorize?client_id=app&response_type=token"

    // CACOMI-EXPECT[SecretPatternRule|high]: OAuth redirect_uri over cleartext http
    static let insecureRedirect =
        "https://idp.example.com/authorize?client_id=app&redirect_uri=http://app.example.com/callback"

    // CACOMI-EXPECT[SecretPatternRule|high]: bearer token baked into a request
    static func authorize(_ request: inout URLRequest) {
        request.setValue("Bearer abcdefghijklmnop1234567890",
                         forHTTPHeaderField: "Authorization")
    }

    // ── Negative controls (must stay silent) ────────────────────────────────

    // CACOMI-NEGATIVE[SecretPatternRule]: Authorization Code flow with PKCE (secure form)
    static let secureAuthURL =
        "https://idp.example.com/authorize?client_id=app&response_type=code&code_challenge=xyz"

    // CACOMI-NEGATIVE[SecretPatternRule]: HTTPS redirect_uri (secure form)
    static let secureRedirect =
        "https://idp.example.com/authorize?redirect_uri=https://app.example.com/callback"

    // CACOMI-NEGATIVE[SecretPatternRule]: documentation placeholder, not a real key
    static let placeholderKey = "YOUR_API_KEY_HERE"

    static func referenceAll() {
        _ = (azureClientSecret, supabaseURL, gitlabRunner, basicAuthURL, smtpURL,
             twilioSid, twilioToken, sendgrid, pemCertificate, oauthClientSecret,
             implicitAuthURL, insecureRedirect, secureAuthURL, secureRedirect,
             placeholderKey)
        var req = URLRequest(url: URL(string: "https://api.example.com")!)
        authorize(&req)
    }
}
