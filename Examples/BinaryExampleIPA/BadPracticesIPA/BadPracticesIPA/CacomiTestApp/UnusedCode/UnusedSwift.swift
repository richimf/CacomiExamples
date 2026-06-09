//
//  UnusedSwift.swift
//  CacomiTestApp
//
//  Fixtures for unused-code detection (positives).
//

import Foundation

// CACOMI-EXPECT[UnusedCode|low]: private function never called
private func neverCalledHelper() -> Int { 42 }

// CACOMI-EXPECT[UnusedCode|low]: struct never referenced
struct OrphanRecord {
    let id: Int
    let name: String
}

// CACOMI-EXPECT[UnusedCode|low]: enum never referenced
enum OrphanColor {
    case red, green, blue
}

enum UnusedHolder {
    // CACOMI-EXPECT[UnusedCode|low]: private property never read
    private static var unreadCounter: Int = 0

    static func touch() {
        // intentionally not reading unreadCounter to mark it as unused
    }
}

// CACOMI-EXPECT[UnusedCode|low]: extension method never called
extension String {
    func reversedTwiceUnused() -> String {
        return String(self.reversed().reversed())
    }
}
