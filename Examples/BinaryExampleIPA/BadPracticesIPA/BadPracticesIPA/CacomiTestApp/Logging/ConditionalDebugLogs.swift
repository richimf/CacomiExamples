//
//  ConditionalDebugLogs.swift
//  CacomiTestApp
//
//  P1 parity: sensitive logs that survive because they are wrapped in a
//  runtime condition (previously missed by line-start-only matchers).
//  ALL VALUES ARE FAKE — intentional bad practice for testing only.
//

import Foundation
import os.log

enum ConditionalDebugLogs {

    // CACOMI-EXPECT[LogParser|medium]: password logged inside a runtime if-branch
    static func log1(_ password: String) {
        if ProcessInfo.processInfo.environment["DBG"] != nil {
            print("password=\(password)")
        }
    }

    // CACOMI-EXPECT[LogParser|medium]: token logged inside a ternary expression
    static func log2(_ token: String, verbose: Bool) {
        verbose ? NSLog("auth token = %@", token) : ()
    }

    // CACOMI-EXPECT[LogParser|medium]: secret logged behind a guard / early-return flag
    static func log3(_ apiKey: String, _ enabled: Bool) {
        guard enabled else { return }
        os_log("api key: %@", apiKey)
    }

    // CACOMI-EXPECT[LogParser|critical]: full credit card written to the log
    static func log4(_ pan: String) {
        NSLog("charging card %@", pan)
    }

    // CACOMI-NEGATIVE[LogParser]: already wrapped in #if DEBUG (stripped from release)
    static func safeLog(_ token: String) {
        #if DEBUG
        print("token=\(token)")
        #endif
    }

    // CACOMI-NEGATIVE[LogParser]: non-sensitive value, no secret identifier
    static func countLog(_ count: Int) {
        print("loaded \(count) rows")
    }

    static func referenceAll() {
        log1("pw")
        log2("tk", verbose: true)
        log3("key", true)
        log4("4111111111111111")
        safeLog("tk")
        countLog(3)
    }
}
