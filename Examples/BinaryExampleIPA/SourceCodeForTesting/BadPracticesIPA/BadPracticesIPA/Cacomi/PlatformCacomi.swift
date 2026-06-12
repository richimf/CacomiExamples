//
//  PlatformCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: UnsafePlatformAPI + PII patterns.
//

import Foundation
import UIKit

enum PlatformCacomi {

    static func openUntrustedURL(_ raw: String) {
        guard let url = URL(string: raw) else { return }
        // BAD: UIApplication.open with unvalidated URL      // CACOMI-EXPECT: UnsafePlatformAPI
        UIApplication.shared.open(url)
    }

    static func invokeSelectorFromString(target: NSObject, name: String) {
        let sel = NSSelectorFromString(name)
        if target.responds(to: sel) {
            // BAD: dynamic selector dispatch                 // CACOMI-EXPECT: UnsafePlatformAPI
            _ = target.perform(sel)
        }
    }

    static func deprecatedDataTask() {
        let url = URL(string: "https://api.fake-cacomi.com")!
        // BAD: deprecated -[NSURLConnection sendSyncRequest] // CACOMI-EXPECT: UnsafePlatformAPI
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        var resp: URLResponse?
        _ = try? NSURLConnection.sendSynchronousRequest(req, returning: &resp)
    }

    // MARK: - PII hardcoded examples (dummy)

    // BAD: PII email hardcoded                              // CACOMI-EXPECT: PIIPattern
    static let piiEmail = "john.doe@example.com"
    // BAD: PII phone hardcoded                              // CACOMI-EXPECT: PIIPattern
    static let piiPhone = "+1-415-555-0199"
    // BAD: SSN format                                       // CACOMI-EXPECT: PIIPattern
    static let piiSSN = "123-45-6789"
    // BAD: IBAN with valid checksum (DE)                    // CACOMI-EXPECT: PIIPattern
    static let piiIBAN = "DE89370400440532013000"
    // BAD: Luhn-valid 16-digit PAN (test card)              // CACOMI-EXPECT: PIIPattern
    static let piiCard = "4111 1111 1111 1111"

    // GOOD: 16-digit number that fails Luhn                  // CACOMI-EXPECT: none
    static let notACard = "1234567890123456"
}
