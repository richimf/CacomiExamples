//
//  AntiTampering.swift
//  CacomiTestApp
//
//  Fixtures for ResilienceFlagRule and UnsafePlatformAPIRule.
//

import Foundation
import UIKit

enum AntiTampering {

    // CACOMI-EXPECT[ResilienceFlagRule|medium]: jailbreak detection function exists but always returns false
    static func isDeviceJailbroken() -> Bool {
        return false
    }

    // CACOMI-EXPECT[ResilienceFlagRule|medium]: debugger detection never implemented
    static func isDebuggerAttached() -> Bool {
        return false
    }

    static func openArbitrary(_ raw: String) {
        guard let url = URL(string: raw) else { return }
        // CACOMI-EXPECT[UnsafePlatformAPIRule|high]: UIApplication.open invoked with unvalidated URL
        UIApplication.shared.open(url)
    }

    static func performBySelectorName(target: NSObject, name: String) {
        let sel = NSSelectorFromString(name)
        if target.responds(to: sel) {
            // CACOMI-EXPECT[UnsafePlatformAPIRule|high]: dynamic selector invocation with external string
            _ = target.perform(sel)
        }
    }
}
