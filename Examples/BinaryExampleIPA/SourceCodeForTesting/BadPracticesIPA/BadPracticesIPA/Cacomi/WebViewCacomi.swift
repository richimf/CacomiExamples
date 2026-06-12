//
//  WebViewCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: WKWebView misuse.
//

import Foundation
@preconcurrency import WebKit

enum WebViewCacomi {

    static func makeMisusedWebView(userInput: String) -> WKWebView {
        let webView = WKWebView()

        // BAD: allowFileAccessFromFileURLs enabled via KVC // CACOMI-EXPECT: WebViewMisuse
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        // BAD: allowUniversalAccessFromFileURLs via KVC    // CACOMI-EXPECT: WebViewMisuse
        webView.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")

        // BAD: cleartext HTTP load                          // CACOMI-EXPECT: insecureHTTP
        if let url = URL(string: "http://www.fake-cacomi.com") {
            webView.load(URLRequest(url: url))
        }

        // BAD: evaluateJavaScript with untrusted input      // CACOMI-EXPECT: WebViewMisuse
        let js = "document.title = '\(userInput)';"
        webView.evaluateJavaScript(js)

        return webView
    }

    // GOOD: static HTTPS, no JS bridge, no file access     // CACOMI-EXPECT: none
    static func makeSafeWebView() -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: "https://www.fake-cacomi.com/help") {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
}
