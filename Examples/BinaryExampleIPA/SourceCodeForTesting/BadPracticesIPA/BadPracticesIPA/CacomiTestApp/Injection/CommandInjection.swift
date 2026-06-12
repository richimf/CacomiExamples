//
//  CommandInjection.swift
//  CacomiTestApp
//
//  Fixtures for InjectionRules (command).
//

import Foundation

enum CommandInjectionCases {

    static func runUserCommand(name: String) {
        // CACOMI-EXPECT[InjectionRules|critical]: shell command built from user input
        let cmd = "/bin/sh -c \"echo \(name); cat /etc/passwd\""
        #if os(macOS)
        let p = Process()
        p.launchPath = "/bin/sh"
        p.arguments = ["-c", cmd]
        try? p.run()
        #else
        // On iOS Process is unavailable; the literal still appears in the binary.
        _ = cmd
        #endif
    }

    static func systemCallConcat(arg: String) {
        // CACOMI-EXPECT[InjectionRules|critical]: literal "system(" with concatenated arg (system() is unavailable on iOS, kept as string sink)
        let str = "system(\"uname -a; " + arg + "\")"
        _ = str
    }

    // CACOMI-NEGATIVE[InjectionRules]: fixed command with no untrusted input
    static func runStaticCommand() {
        _ = "/usr/bin/true"
    }
}
