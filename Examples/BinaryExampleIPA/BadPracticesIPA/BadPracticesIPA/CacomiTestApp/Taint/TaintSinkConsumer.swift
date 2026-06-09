//
//  TaintSinkConsumer.swift
//  CacomiTestApp
//
//  Fixtures for CrossFileTaintAnalyzer: consumes the cross-file source.
//  Expected confidence is medium because the analyzer must connect the
//  helper in TaintSourceHelper.swift with the sink in this file.
//

import Foundation

enum TaintSinkConsumer {

    static func runSearchDirect() {
        // CACOMI-EXPECT[CrossFileTaint|high]: tainted helper result flows directly into DB.execute
        DB().execute(TaintSourceHelper.fetchUserInput())
    }

    static func runSearchTwoStep() {
        // CACOMI-EXPECT[CrossFileTaint|high]: tainted helper assigned then flows into DB.execute
        let v = TaintSourceHelper.fetchUserInput()
        DB().execute(v)
    }

    // CACOMI-NEGATIVE[CrossFileTaint]: helper has no source so this sink should not be tainted
    static func runSearchSafe() {
        DB().execute(TaintSourceHelper.makeGreeting())
    }
}
