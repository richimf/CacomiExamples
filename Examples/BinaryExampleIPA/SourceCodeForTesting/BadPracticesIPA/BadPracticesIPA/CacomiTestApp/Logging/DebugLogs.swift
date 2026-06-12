//
//  DebugLogs.swift
//  CacomiTestApp
//
//  Fixtures for LogParser: print/NSLog/os_log/Logger.
//

import Foundation
import os

enum DebugLogs {

    static let authToken = "eyJhbGciOiJIUzI1NiJ9.payload.sig"
    static let logger = Logger(subsystem: "com.cacomi.test", category: "auth")

    static func emitAllLogs() {
        // CACOMI-EXPECT[LogParser|low]: print used (not wrapped in #if DEBUG)
        print("hello from print")

        // CACOMI-EXPECT[LogParser|low]: debugPrint used (not wrapped in #if DEBUG)
        debugPrint("hello from debugPrint")

        // CACOMI-EXPECT[LogParser|medium]: NSLog used (not wrapped in #if DEBUG)
        NSLog("hello from NSLog")

        // CACOMI-EXPECT[LogParser|medium]: os_log used (not wrapped in #if DEBUG)
        os_log("hello from os_log")

        // CACOMI-EXPECT[LogParser|medium]: Logger().debug used (not wrapped in #if DEBUG)
        logger.debug("hello from Logger.debug")

        // CACOMI-EXPECT[LogParser|critical]: log leaks sensitive token interpolated into message
        print("token=\(authToken)")
    }

    static func emitProtectedLogs() {
        #if DEBUG
        // CACOMI-NEGATIVE[LogParser]: log already wrapped in #if DEBUG
        print("debug-only diagnostics")
        NSLog("debug-only NSLog")
        #endif
    }
}
