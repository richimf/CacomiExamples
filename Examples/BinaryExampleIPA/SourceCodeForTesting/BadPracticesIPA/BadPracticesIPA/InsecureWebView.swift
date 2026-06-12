//
//  InsecureWebView.swift
//  BadPracticesIPA
//
//  Examples of insecure WebView usage: enabled JS, file:// access,
//  injecting untrusted HTML, exposing secrets to JS bridge.
//

import SwiftUI
@preconcurrency import WebKit

struct InsecureWebView: UIViewRepresentable {

    let untrustedHTML: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let prefs = WKPreferences()
        // BAD: enabling JS for arbitrary HTML
        prefs.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = prefs

        let pagePrefs = WKWebpagePreferences()
        pagePrefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pagePrefs

        // BAD: allow inline media playback without restrictions
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // BAD: expose secrets to the JS bridge as a userScript
        let secretsScript = """
        window.__APP_SECRETS__ = {
            apiKey: "\(BadSecrets.productionApiKey)",
            jwt: "\(BadSecrets.jwtSigningSecret)",
            stripe: "\(BadSecrets.stripeSecretKey)"
        };
        """
        let script = WKUserScript(
            source: secretsScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        config.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: config)
        // BAD: directly injecting untrusted HTML (XSS sink)
        webView.loadHTMLString(
            "<html><body>\(untrustedHTML)</body></html>",
            baseURL: URL(string: "http://insecure.fake-cacomi.com")
        )
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // BAD: directly evaluating untrusted JavaScript string
        let js = "document.body.innerHTML += '\(untrustedHTML)';"
        webView.evaluateJavaScript(js)
    }
}

enum InsecureDeepLink {
    // BAD: opens any URL coming from outside the app without validation
    static func handle(_ url: URL) {
        if url.scheme == "cacomi" {
            // BAD: leak token to query of returned URL
            let echo = URL(string: "http://echo.fake-cacomi.com/?token=\(BadSecrets.refreshToken)")!
            UIApplication.shared.open(echo)
        } else {
            UIApplication.shared.open(url)
        }
    }
}
