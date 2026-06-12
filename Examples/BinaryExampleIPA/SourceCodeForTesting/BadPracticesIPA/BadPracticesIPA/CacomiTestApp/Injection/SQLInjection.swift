//
//  SQLInjection.swift
//  CacomiTestApp
//
//  Fixtures for InjectionRules (SQL) and intra-file TaintAnalyzer.
//

import Foundation

struct DB {
    func execute(_ query: String) {
        // stub for analyzer
        _ = query
    }
    func prepared(_ query: String, _ params: [Any]) {
        _ = (query, params)
    }
}

enum SQLInjectionCases {

    static func searchUserConcat(userInput: String) {
        // CACOMI-EXPECT[InjectionRules|critical]: SQL built by string concatenation reaches execute
        let query = "SELECT * FROM users WHERE name = '" + userInput + "'"
        // CACOMI-EXPECT[TaintAnalyzer|high]: tainted value flows into DB.execute within same function
        DB().execute(query)
    }

    static func searchUserInterpolation(userInput: String) {
        // CACOMI-EXPECT[InjectionRules|critical]: SQL built by string interpolation reaches execute
        let q = "SELECT * FROM u WHERE id = \(userInput)"
        DB().execute(q)
    }

    static func searchUserParameterized(userInput: String) {
        // CACOMI-NEGATIVE[InjectionRules]: query uses placeholders with bound parameters
        let q = "SELECT * FROM u WHERE id = ?"
        DB().prepared(q, [userInput])
    }
}
