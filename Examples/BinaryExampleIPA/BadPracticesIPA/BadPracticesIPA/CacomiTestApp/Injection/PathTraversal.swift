//
//  PathTraversal.swift
//  BadPracticesIPA
//
//  Cacomi fixture: path-traversal via unsanitized external input (M4 — Insecure Authentication / Input Validation).
//  All filenames and payloads are FAKE/dummy — for static-analysis testing only.
//

import Foundation

enum PathTraversalCases {

    // BAD: URL query parameter appended directly to documents directory path.
    // An attacker can supply "../../../private/etc/passwd" to escape the sandbox (on jailbroken device).
    static func readFileFromURLParam(userSuppliedFilename: String) -> String? {
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // CACOMI-EXPECT[InputValidation|critical]: user-supplied filename appended to path without sanitization — path traversal allows sandbox escape
        let targetURL = docsDir.appendingPathComponent(userSuppliedFilename)
        return try? String(contentsOf: targetURL, encoding: .utf8)
    }

    // BAD: String(contentsOfFile:) with attacker-controlled path string.
    // If userInput contains "../" sequences the app reads arbitrary accessible files.
    static func readRawPath(userInput: String) -> String? {
        let basePath = NSHomeDirectory() + "/Documents/"
        // CACOMI-EXPECT[InputValidation|critical]: attacker-controlled path string passed to String(contentsOfFile:) without validation — arbitrary file read
        let fullPath = basePath + userInput
        return try? String(contentsOfFile: fullPath, encoding: .utf8)
    }

    // BAD: FileManager.contents(atPath:) with a path built from unsanitised deep-link component.
    static func readDeepLinkResource(deepLinkPath: String) -> Data? {
        let base = Bundle.main.bundlePath + "/Resources/"
        // CACOMI-EXPECT[InputValidation|high]: deep-link path component concatenated to bundle resource path — traversal into app container or system directories
        let resolved = (base as NSString).appendingPathComponent(deepLinkPath)
        return FileManager.default.contents(atPath: resolved)
    }

    // BAD: writing to a path derived from untrusted remote JSON field.
    // Attacker can overwrite arbitrary writable files inside the app's container.
    static func writeRemoteContent(remoteFilename: String, content: Data) {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        // CACOMI-EXPECT[InputValidation|critical]: remote-controlled filename used to construct write path — path traversal enables overwriting sensitive container files
        let dest = cacheDir.appendingPathComponent(remoteFilename)
        try? content.write(to: dest)
    }

    // BAD: NSString pathWithComponents used with unsanitized array element from URL params.
    static func buildPathFromComponents(components: [String]) -> String {
        // CACOMI-EXPECT[InputValidation|high]: NSString.path(withComponents:) called with array containing unsanitized URL-param segments — traversal via ".." components
        return NSString.path(withComponents: components)
    }

    // MARK: - Negative cases

    // GOOD: filename sanitized — strip directory separators and ensure no ".." sequences.
    static func readFileSafely(userSuppliedName: String) -> String? {
        // CACOMI-NEGATIVE[InputValidation]: lastPathComponent strips any directory traversal prefix; guard rejects remaining ".." sequences
        let sanitized = (userSuppliedName as NSString).lastPathComponent
        guard !sanitized.contains(".."), !sanitized.isEmpty else { return nil }
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let target = docsDir.appendingPathComponent(sanitized)
        // Ensure resolved path is still inside the documents directory.
        guard target.path.hasPrefix(docsDir.path) else { return nil }
        return try? String(contentsOf: target, encoding: .utf8)
    }

    // GOOD: only known, allowlisted filenames are accepted.
    static func readAllowlistedResource(name: String) -> Data? {
        let allowed: Set<String> = ["report.json", "config.json", "changelog.txt"]
        // CACOMI-NEGATIVE[InputValidation]: strict allowlist prevents any traversal
        guard allowed.contains(name) else { return nil }
        let path = Bundle.main.bundlePath + "/Resources/" + name
        return FileManager.default.contents(atPath: path)
    }
}
