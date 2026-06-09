//
//  TaintSourceHelper.swift
//  CacomiTestApp
//
//  Fixtures for CrossFileTaintAnalyzer: defines a known source.
//

import Foundation

enum TaintSourceHelper {

    // Source function: returns a value originating from a known taint source
    // (process environment) — expected to be tracked across files.
    static func fetchUserInput() -> String {
        // CACOMI-EXPECT[CrossFileTaint|high]: source reads ProcessInfo.environment -> returned to caller
        return ProcessInfo.processInfo.environment["Q"] ?? ""
    }

    // CACOMI-NEGATIVE[CrossFileTaint]: helper returns a constant, does not touch any source
    static func makeGreeting() -> String {
        return "hello"
    }
}
