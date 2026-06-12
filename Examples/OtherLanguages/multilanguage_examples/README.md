# Cacomi Multilanguage Fixtures

This ZIP contains intentionally unsafe and intentionally unused code examples for testing Cacomi.

Each folder contains a fixture for a language or platform:

- `java`
- `kotlin`
- `objective-c`
- `swiftui`
- `rust`
- `python_ml_ai`
- `javascript`
- `typescript`
- `shell`
- `go`
- `c_cpp`

The files include many variants of:

- Explicit unused code named with `unused_*`
- Hardcoded secrets
- Sensitive logs
- HTTP URLs
- Weak crypto
- Local storage or insecure configuration examples where relevant
- SSL validation bypass patterns
- Debug/test code risks

These files are intentionally unsafe and should never be used in production.

## Unused-code and print/log detection fixtures

Each fixture file now contains a dedicated section clearly delimited by the banner comment:

```
// ===== Cacomi: extra unused-code & logging fixtures =====
```

(Shell and Python use `#` comment syntax.)

This section exercises two Cacomi detection features specifically:

**Unused-code detection** — each file adds:
- An unused function/method (named with an `unused_` prefix)
- An unused variable/constant
- An unused type (struct, class, enum, interface, or data class as appropriate for the language)
- An unused import (commented-out in languages where a real unused import would be a compile error, left as a comment marker in others)

All unused-code items are annotated with `// CACOMI-EXPECT: UnusedCode` (or `# CACOMI-EXPECT: UnusedCode` for Python/Shell).

**Print and log detection** — each file adds:
- At least two print/log call-sites that emit sensitive values (passwords, tokens, API keys, JWTs) using the idiomatic logging API for that language
- Items are annotated with `// CACOMI-EXPECT: PrintAndLogs`
- At least one negative example (`// CACOMI-EXPECT: none`) that logs a non-sensitive value (e.g. an item count) to confirm the detector does not over-fire

## How to use: 

You can review all codes at the same time by scanning the folder: `multilanguage_examples`.

