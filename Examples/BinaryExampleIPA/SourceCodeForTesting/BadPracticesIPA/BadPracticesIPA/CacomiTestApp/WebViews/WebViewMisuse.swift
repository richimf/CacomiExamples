//
//  WebViewMisuse.swift
//  CacomiTestApp
//
//  Fixtures for WebViewMisuseExtrasRule and MobileMisuseRules.
//

import Foundation
import WebKit

enum WebViewMisuse {

    static func makeUnsafeWebView(userContent: String) -> WKWebView {
        let webView = WKWebView()
        // CACOMI-EXPECT[WebViewMisuseExtrasRule|high]: allowsUniversalAccessFromFileURLs enabled via KVC
        webView.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        // CACOMI-EXPECT[WebViewMisuseExtrasRule|high]: allowFileAccessFromFileURLs enabled via KVC
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        // CACOMI-EXPECT[MobileMisuseRules|high]: loadHTMLString with dynamically constructed HTML
        let html = "<html><body><h1>\(userContent)</h1></body></html>"
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    static func makeSafeWebView() -> WKWebView {
        let webView = WKWebView()
        // CACOMI-NEGATIVE[WebViewMisuseExtrasRule]: static HTTPS request, no JS bridge, no file access
        if let url = URL(string: "https://www.fake-cacomi.com/help") {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
}
