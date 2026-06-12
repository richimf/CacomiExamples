//
//  InsecureNetworking.swift
//  BadPracticesIPA
//
//  Examples of insecure networking: HTTP endpoints, disabled
//  certificate validation, leaking secrets in URLs, etc.
//

import Foundation

final class InsecureNetworking: NSObject {

    static let shared = InsecureNetworking()

    // MARK: - Cleartext HTTP endpoints (BAD)

    static let loginEndpoint   = "http://login.fake-cacomi.com/api/v1/login"
    static let analyticsBeacon = "http://analytics.fake-cacomi.com/track"
    static let downloadHost    = "http://downloads.fake-cacomi.com"

    // MARK: - URLSession that disables certificate validation (BAD)

    private lazy var insecureSession: URLSession = {
        let config = URLSessionConfiguration.default
        // BAD: never disable system protections in production
        config.tlsMinimumSupportedProtocolVersion = .TLSv10
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )
    }()

    func performLogin(user: String, password: String) {
        // BAD: secrets passed in query string of an http:// URL
        guard var components = URLComponents(string: Self.loginEndpoint) else { return }
        components.queryItems = [
            URLQueryItem(name: "user", value: user),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "api_key", value: BadSecrets.productionApiKey)
        ]
        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = BadSecrets.buildUnsafeHeaders()

        insecureSession.dataTask(with: request) { data, _, _ in
            // BAD: logging the response body
            if let data, let body = String(data: data, encoding: .utf8) {
                NSLog("LOGIN_RESPONSE: %@", body)
            }
        }.resume()
    }

    func uploadSecretsViaHTTP() {
        guard let url = URL(string: Self.analyticsBeacon) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let payload: [String: Any] = [
            "api_key": BadSecrets.productionApiKey,
            "jwt_secret": BadSecrets.jwtSigningSecret,
            "db_connection": BadSecrets.dbConnectionString,
            "stripe_key": BadSecrets.stripeSecretKey
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        insecureSession.dataTask(with: request).resume()
    }

    // MARK: - SSRF-style: build URL from untrusted string

    func fetchUntrustedURL(_ raw: String) {
        // BAD: blindly trusting external input as URL
        guard let url = URL(string: raw) else { return }
        insecureSession.dataTask(with: url).resume()
    }
}

// MARK: - Disabled certificate validation (BAD)

extension InsecureNetworking: URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        ) -> Void
    ) {
        // BAD: blindly trust any server certificate, no pinning, no validation.
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

// MARK: - SQL Injection-ish helper (anti-pattern even client-side)

enum InsecureQueries {
    static func buildLoginQuery(user: String, password: String) -> String {
        // BAD: string concatenation = SQL injection
        return "SELECT * FROM users WHERE username='\(user)' AND password='\(password)';"
    }

    static func runFakeShell(_ command: String) {
        // BAD: shell-style concatenation, illustrative only
        let injected = "/bin/sh -c \"echo \(command); cat /etc/passwd\""
        print("Would run: \(injected)")
    }
}
