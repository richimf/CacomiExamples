//
//  NSPredicateInjection.swift
//  CacomiTestApp
//
//  P1 parity: NSPredicate format-string injection (M4 input/output validation).
//  ALL VALUES ARE FAKE — intentional bad practice for testing only.
//

import Foundation

enum NSPredicateInjection {

    // CACOMI-EXPECT[InjectionRules|high]: user input interpolated into NSPredicate format string
    static func find(_ userInput: String) -> NSPredicate {
        return NSPredicate(format: "name == \(userInput) AND active == 1")
    }

    // CACOMI-EXPECT[InjectionRules|high]: format string built by concatenation with input
    static func filter(_ field: String, _ value: String) -> NSPredicate {
        let format = "\(field) CONTAINS '" + value + "'"
        return NSPredicate(format: format)
    }

    // CACOMI-EXPECT[InjectionRules|high]: CoreData fetch with interpolated predicate
    static func fetchFormat(_ email: String) -> NSPredicate {
        return NSPredicate(format: "email == \"\(email)\"")
    }

    // CACOMI-NEGATIVE[InjectionRules]: parameterised predicate with bound argument (secure form)
    static func findSafe(_ userInput: String) -> NSPredicate {
        return NSPredicate(format: "name == %@ AND active == 1", userInput)
    }

    // CACOMI-NEGATIVE[InjectionRules]: constant predicate, no untrusted input
    static func activeOnly() -> NSPredicate {
        return NSPredicate(format: "active == 1")
    }

    static func referenceAll() {
        _ = find("x")
        _ = filter("name", "y")
        _ = fetchFormat("a@b.com")
        _ = findSafe("z")
        _ = activeOnly()
    }
}
