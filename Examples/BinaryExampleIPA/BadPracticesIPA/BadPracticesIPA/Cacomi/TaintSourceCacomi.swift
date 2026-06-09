//
//  TaintSourceCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: taint SOURCE for the cross-file taint flow.
//

import Foundation

enum TaintSourceCacomi {

    static func readEnvQuery() -> String {
        // BAD: untrusted source returned to caller          // CACOMI-EXPECT: TaintAnalyzer
        return ProcessInfo.processInfo.environment["Q"] ?? ""
    }

    // GOOD: returns a constant, no taint                     // CACOMI-EXPECT: none
    static func staticGreeting() -> String { "hello" }
}
