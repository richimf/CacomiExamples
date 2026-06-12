//
//  LogsCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: print/debugPrint/NSLog/os_log/Logger.
//

import Foundation
import os

enum LogsCacomi {

    static let token = "eyJhbGciOiJIUzI1NiJ9.payload.sig" // dummy JWT
    static let password = "P@ssw0rd!2024"               // dummy
    static let logger = Logger(subsystem: "com.cacomi.demo", category: "auth")

    static func leakAll() {
        // BAD: print with sensitive token                // CACOMI-EXPECT: PrintAndLogs
        print("[auth] token=\(token)")

        // BAD: debugPrint with sensitive password         // CACOMI-EXPECT: PrintAndLogs
        debugPrint("[auth] password=\(password)")

        // BAD: NSLog leaks token                          // CACOMI-EXPECT: PrintAndLogs
        NSLog("[auth] token=%@", token)

        // BAD: os_log leaks token (public)                // CACOMI-EXPECT: PrintAndLogs
        os_log("auth token=%{public}@", token)

        // BAD: Logger leaks password                      // CACOMI-EXPECT: PrintAndLogs
        logger.debug("password=\(password, privacy: .public)")
    }

    static func protectedLogs() {
        #if DEBUG
        // GOOD: log only in DEBUG, should not be flagged // CACOMI-EXPECT: none
        print("[debug-only] diagnostics enabled")
        NSLog("[debug-only] NSLog wrapped")
        #endif
    }
}
