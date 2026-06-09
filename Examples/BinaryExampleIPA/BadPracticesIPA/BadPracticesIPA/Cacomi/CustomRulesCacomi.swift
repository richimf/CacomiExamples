//
//  CustomRulesCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: targets for user-defined custom rules
//  (regex secret pattern + forbidden API).
//

import Foundation

enum LegacyAnalytics {
    static func track(_ event: String, properties: [String: Any] = [:]) {
        _ = (event, properties)
    }
}

enum CustomRulesCacomi {

    // BAD: fictional corporate token matching ACME_[A-Z0-9]{32}  // CACOMI-EXPECT: CustomRule
    static let acmeCorpToken = "ACME_AB12CD34EF56GH78IJ90KL12MN34OP56"

    static func useForbiddenLegacyAPI() {
        // BAD: call to internal forbidden API                    // CACOMI-EXPECT: ForbiddenAPI
        LegacyAnalytics.track("login", properties: ["user": "ricardo"])
    }

    // GOOD: tokens that DO NOT match ACME_ pattern               // CACOMI-EXPECT: none
    static let acmeLooksAlike1 = "ACMELONG_NOTMATCH_SHORT"
    static let acmeLooksAlike2 = "acme_lowercase_doesnt_match_pattern_abc12"
}
