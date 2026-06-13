// NonSecretVerbatimControls.swift
//
// Negative control for masking. These findings are NOT secret-bearing
// (WebView misuse, AI usage), so Cacomi must show their preview VERBATIM -
// masking them would destroy the locating signal the developer needs.
// If any line below shows up masked, the secret-bearing classifier is
// over-masking (regression in SecurityFinding.isSecretBearing).
//
// See ../EXPECTED.md for ground truth.

import WebKit

enum NonSecretControls {

    static func configureWebView(_ webView: WKWebView) {
        // EXPECT: webViewMisuse · shown VERBATIM (not a secret).
        webView.configuration.preferences.javaScriptEnabled = true
    }

    // EXPECT: this plain line is NOT a finding at all (no detector should fire).
    static let appName = "Cacomi Example App"

    // EXPECT: aiUsage (informational/medium) · shown VERBATIM - the endpoint
    // string is the signal the reviewer needs to confirm the integration.
    static let inferenceEndpoint = "https://api.openai.com/v1/chat/completions"
}
