//
//  PIIData.swift
//  CacomiTestApp
//
//  Fixtures for PIIPatternRule.
//

import Foundation

enum PIIData {

    // CACOMI-EXPECT[PIIPatternRule|critical]: valid Luhn 16-digit PAN (test card)
    static let creditCardLuhnValid = "4111 1111 1111 1111"

    // CACOMI-EXPECT[PIIPatternRule|high]: US SSN format
    static let ssn = "123-45-6789"

    // CACOMI-EXPECT[PIIPatternRule|high]: IBAN with valid checksum (DE)
    static let iban = "DE89370400440532013000"

    // CACOMI-NEGATIVE[PIIPatternRule]: 16-digit number that FAILS Luhn check
    static let notACard = "1234567890123456"

    // CACOMI-NEGATIVE[PIIPatternRule]: reserved SSN area (000-..) is not a real SSN
    static let reservedSSN = "000-12-3456"
}
