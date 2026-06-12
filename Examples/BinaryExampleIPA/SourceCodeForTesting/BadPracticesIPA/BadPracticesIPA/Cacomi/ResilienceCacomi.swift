//
//  ResilienceCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: ResilienceAbsence / ResilienceFlag.
//

import Foundation

enum ResilienceCacomi {

    // BAD: debug feature flag enabled in runtime           // CACOMI-EXPECT: ResilienceFlag
    static var debugMenuEnabled = true
    // BAD: cert pinning disabled by flag                   // CACOMI-EXPECT: ResilienceFlag
    static let skipCertPinning = true
    // BAD: anti-debug disabled                              // CACOMI-EXPECT: ResilienceFlag
    static let antiDebugEnabled = false

    // BAD: jailbreak check never implemented (always false) // CACOMI-EXPECT: ResilienceAbsence
    static func isDeviceJailbroken() -> Bool { false }

    static func makeNetworkRequest() {
        // BAD: network request without certificate pinning  // CACOMI-EXPECT: ResilienceAbsence
        let url = URL(string: "https://api.fake-cacomi.com/v1/me")!
        URLSession.shared.dataTask(with: url).resume()
    }
}
