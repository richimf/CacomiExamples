// DynamicLoadingAndScripts.swift
//
// Dynamic-behaviour fixtures (Apple side). After the Tier 6 detector
// additions, dlopen/dlsym and embedded-script eval are now DETECTED (via
// UnsafePlatformAPIRule). Background-execution abuse remains a documented
// gap. Tags below reflect the current status.
//
// All values are FAKE. See ../EXPECTED.md.

import Foundation

enum DynamicBehaviourGaps {

    // EXPECT: dynamic library loading (dlopen/dlsym) - DETECTED (informational).
    static func loadPlugin(at path: String) {
        guard let handle = dlopen(path, RTLD_NOW) else { return }
        _ = dlsym(handle, "entryPoint")
    }

    // EXPECT: embedded-script eval - DETECTED (the `eval(` surface is flagged).
    static func runRemoteScript(_ source: String) {
        // An embedded JS/shell payload evaluated at runtime.
        let script = "eval(atob('ZmFrZSBwYXlsb2Fk'))" // fake base64 "fake payload"
        _ = (source, script)
    }

    // EXPECT (GAP): background-execution abuse (BGTaskScheduler) - intentionally
    // not flagged (too noisy as a per-line rule).
    static func scheduleHiddenWork() {
        // Registers indefinite background work; no standalone detector today.
        _ = "BGTaskScheduler.shared.register(forTaskWithIdentifier: \"hidden.refresh\")"
    }
}
