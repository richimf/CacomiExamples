//
//  TaintSinkCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: cross-file taint SINK (SQL / file path).
//

import Foundation

enum TaintSinkCacomi {

    static func runSearchDirect() {
        // BAD: cross-file tainted value -> SQL sink         // CACOMI-EXPECT: CrossFileTaint
        CacomiDB().execute(TaintSourceCacomi.readEnvQuery())
    }

    static func runSearchTwoStep() {
        // BAD: cross-file tainted value -> SQL sink         // CACOMI-EXPECT: CrossFileTaint
        let v = TaintSourceCacomi.readEnvQuery()
        CacomiDB().execute(v)
    }

    static func writeToTaintedPath() {
        let raw = TaintSourceCacomi.readEnvQuery()
        // BAD: tainted value used as file path component   // CACOMI-EXPECT: CrossFileTaint
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(raw)
        try? "x".write(to: url, atomically: true, encoding: .utf8)
    }

    // GOOD: helper has no source so sink should be clean   // CACOMI-EXPECT: none
    static func runSearchSafe() {
        CacomiDB().execute(TaintSourceCacomi.staticGreeting())
    }
}
