//
//  WebSocketInsecure.swift
//  BadPracticesIPA
//
//  Cacomi fixture: insecure WebSocket (ws://) and plain HTTP endpoints (M3 — Insecure Communication).
//  All URLs and tokens are FAKE/dummy — for static-analysis testing only.
//

import Foundation

enum WebSocketInsecureCases {

    // BAD: ws:// WebSocket — no TLS, traffic observable by network intermediaries.
    static func connectInsecureWebSocket() {
        // CACOMI-EXPECT[insecureHTTP|high]: ws:// WebSocket URL transmits data in cleartext — upgrade to wss://
        let url = URL(string: "ws://realtime.fake-cacomi.com:8080/chat")!
        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: url)
        task.resume()

        // Send a message carrying a fake auth token over the unencrypted channel.
        let authPayload = "{\"token\":\"FAKE_CACOMI_WS_TOKEN_abcdef1234567890\"}"
        // CACOMI-EXPECT[insecureHTTP|high]: auth token transmitted over unencrypted ws:// connection
        task.send(.string(authPayload)) { _ in }
    }

    // BAD: ws:// with explicit port — same plaintext exposure, different port.
    static func connectInsecureWebSocketAltPort() {
        // CACOMI-EXPECT[insecureHTTP|high]: ws:// URL with non-standard port — still unencrypted WebSocket
        let url = URL(string: "ws://events.fake-cacomi.com:4000/stream")!
        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: url)
        task.resume()
        task.receive { _ in }
    }

    // BAD: plain http:// REST endpoint — credentials sent unencrypted.
    static func loginOverHTTP(username: String, password: String) {
        // CACOMI-EXPECT[insecureHTTP|high]: http:// endpoint used for login — credentials exposed in cleartext (M3)
        let url = URL(string: "http://api.fake-cacomi.com/v1/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Fake credentials for scanner fixture — never real values.
        let body = "{\"username\":\"\(username)\",\"password\":\"\(password)\"}"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }

    // BAD: http:// used to fetch a session refresh token.
    static func refreshSessionOverHTTP(refreshToken: String) {
        // CACOMI-EXPECT[insecureHTTP|high]: http:// used to transmit a session refresh token — token exposed to MITM
        let urlStr = "http://auth.fake-cacomi.com/token/refresh?token=\(refreshToken)"
        guard let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url).resume()
    }

    // BAD: hardcoded ws:// URL stored as a constant — detectable in binary strings.
    // CACOMI-EXPECT[insecureHTTP|high]: hardcoded ws:// URL literal present in binary — cleartext WebSocket endpoint
    static let insecureWSEndpoint = "ws://push.fake-cacomi.com/notifications"

    // BAD: hardcoded http:// base URL used to build API calls.
    // CACOMI-EXPECT[insecureHTTP|high]: hardcoded http:// base URL — all derived requests are unencrypted
    static let insecureHTTPBase = "http://backend.fake-cacomi.com/api"

    // MARK: - Negative cases

    // GOOD: wss:// WebSocket — TLS-protected, equivalent to HTTPS for WebSockets.
    static func connectSecureWebSocket() {
        // CACOMI-NEGATIVE[insecureHTTP]: wss:// ensures TLS encryption for WebSocket traffic
        let url = URL(string: "wss://realtime.fake-cacomi.com:443/chat")!
        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: url)
        task.resume()
        task.receive { _ in }
    }

    // GOOD: https:// endpoint — TLS mandatory.
    static func loginOverHTTPS(username: String, password: String) {
        // CACOMI-NEGATIVE[insecureHTTP]: https:// encrypts credentials in transit
        let url = URL(string: "https://api.fake-cacomi.com/v1/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "{\"username\":\"\(username)\"}".data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
}
