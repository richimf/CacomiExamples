//
//  AuthSession.swift
//  CacomiTestApp
//
//  Fixtures for AuthSessionRule.
//

import Foundation

enum AuthSession {

    // CACOMI-EXPECT[AuthSessionRule|high]: session never expires (TimeInterval.greatestFiniteMagnitude)
    static let sessionExpiry: TimeInterval = .greatestFiniteMagnitude

    static func loginURL(token: String) -> URL? {
        // CACOMI-EXPECT[AuthSessionRule|high]: bearer token placed in URL query parameter
        return URL(string: "https://api.fake-cacomi.com/session?token=\(token)")
    }

    static func persistSessionCookie(_ value: String) {
        // CACOMI-EXPECT[AuthSessionRule|high]: session cookie stored without HttpOnly/Secure flags
        let cookie = HTTPCookie(properties: [
            .name: "SESSIONID",
            .value: value,
            .domain: "fake-cacomi.com",
            .path: "/"
        ])
        if let cookie = cookie {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }

    // CACOMI-NEGATIVE[AuthSessionRule]: token sent via Authorization header, session has expiry
    static func secureRequest(token: String) -> URLRequest {
        var req = URLRequest(url: URL(string: "https://api.fake-cacomi.com/me")!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.timeoutInterval = 30
        return req
    }
}
