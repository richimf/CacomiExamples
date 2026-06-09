//
//  InjectionCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: SQL/Command Injection + intra-file Taint.
//

import Foundation

struct CacomiDB {
    func execute(_ q: String) { _ = q }
    func prepared(_ q: String, _ params: [Any]) { _ = (q, params) }
}

enum InjectionCacomi {

    static func searchUserSQLConcat(name: String) {
        // BAD: SQL concatenated with untrusted input        // CACOMI-EXPECT: InjectionRules
        let q = "SELECT * FROM users WHERE name = '" + name + "'"
        // BAD: tainted value flows into execute             // CACOMI-EXPECT: TaintAnalyzer
        CacomiDB().execute(q)
    }

    static func searchUserSQLInterp(id: String) {
        // BAD: SQL interpolation of untrusted input         // CACOMI-EXPECT: InjectionRules
        let q = "SELECT * FROM users WHERE id = \(id)"
        CacomiDB().execute(q)
    }

    static func runFakeShell(cmd: String) {
        // BAD: shell command built from user input          // CACOMI-EXPECT: InjectionRules
        let s = "/bin/sh -c \"" + cmd + "\""
        _ = s
    }

    // GOOD: parameterized query                             // CACOMI-EXPECT: none
    static func searchUserParameterized(id: String) {
        CacomiDB().prepared("SELECT * FROM users WHERE id = ?", [id])
    }
}
