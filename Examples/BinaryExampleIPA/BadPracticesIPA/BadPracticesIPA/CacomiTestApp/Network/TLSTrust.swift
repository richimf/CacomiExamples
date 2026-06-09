//
//  TLSTrust.swift
//  CacomiTestApp
//
//  Fixtures for TLSTrustBypassRule.
//

import Foundation

final class AcceptAnyCertDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if let trust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: trust)
            // CACOMI-EXPECT[TLSTrustBypassRule|critical]: accepts any server certificate
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

enum TLSConfig {
    // CACOMI-EXPECT[TLSTrustBypassRule|high]: NSExceptionAllowsInsecureHTTPLoads referenced from code
    static let atsExceptionKey = "NSExceptionAllowsInsecureHTTPLoads"
}

final class PinnedDelegate: NSObject, URLSessionDelegate {
    static let pinnedSPKIHash = Data([0x01, 0x02, 0x03, 0x04])

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        // CACOMI-NEGATIVE[TLSTrustBypassRule]: validates trust with pinning before accepting
        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        var error: CFError?
        let ok = SecTrustEvaluateWithError(trust, &error)
        guard ok,
              let chain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
              let leaf = chain.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let der = SecCertificateCopyData(leaf) as Data
        if der.suffix(4) == Self.pinnedSPKIHash {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
