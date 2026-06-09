//
//  TLSCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: TLS trust bypass + ATS markers.
//

import Foundation

final class TLSAcceptAnyDelegate: NSObject, URLSessionDelegate {

    // BAD: accepts any server certificate                  // CACOMI-EXPECT: TLSTrustBypass
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition,
                                                  URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            let cred = URLCredential(trust: trust)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

enum TLSCacomi {
    // BAD: hardcoded reference to ATS exception key        // CACOMI-EXPECT: TLSTrustBypass
    static let atsExceptionKey = "NSExceptionAllowsInsecureHTTPLoads"
    // BAD: code-side flag promoting ATS bypass              // CACOMI-EXPECT: TLSTrustBypass
    static let nsAllowsArbitraryLoads = true
}

final class TLSPinnedDelegate: NSObject, URLSessionDelegate {

    static let pinnedSPKIHash = Data([0xDE, 0xAD, 0xBE, 0xEF])

    // GOOD: validates trust then pins SPKI                  // CACOMI-EXPECT: none
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition,
                                                  URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust,
              SecTrustEvaluateWithError(trust, nil),
              let chain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
              let leaf = chain.first else {
            completionHandler(.cancelAuthenticationChallenge, nil); return
        }
        let der = SecCertificateCopyData(leaf) as Data
        if der.suffix(4) == Self.pinnedSPKIHash {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
