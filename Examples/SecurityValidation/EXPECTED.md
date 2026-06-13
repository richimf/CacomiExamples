# Expected Results — Security Validation Pack

Ground truth for the fixtures in this folder. Every secret value is FAKE and
exists only to exercise Cacomi. This pack validates the masking and
hardening changes (CR-1, H-4, H-1), plus documents current detection gaps.

## 1. Masking (CR-1 / H-4) — `Masking/SecretsMaskingShowcase.swift`

Each line must be reported as a hardcoded-secret finding, and the value must
be shown MASKED everywhere it surfaces by default: the inline preview, the
"Copy" action (clipboard), and every exported report (PDF / SARIF / JSON /
Markdown / HTML). The full value is allowed ONLY behind the explicit
"Reveal value" toggle (or the "View full key value" sheet for PEM blocks).

| Symbol | Category | Severity | Masking requirement |
|---|---|---|---|
| `awsKeyID` | Hardcoded secret | Critical | masked; at most a short head/tail hint (e.g. `AKIA…MPLE`) |
| `stripeLive` | Hardcoded secret | Critical | masked |
| `githubToken` | Hardcoded secret | High | masked |
| `dbURL` | Hardcoded secret | Critical | masked (host may remain; credentials masked) |
| `bearer` | Hardcoded secret | High | masked |
| `pemPrivateKey` | Hardcoded secret | Critical | BODY masked in the inline preview; full block only via "View full key value" |

Pass criteria: no full secret value appears in the inline preview, the
clipboard after "Copy", or any exported report. Revealing must show the
verbatim value.

## 2. Masking negative control — `Masking/NonSecretVerbatimControls.swift`

These must be shown VERBATIM (they are not secret-bearing). If any appears
masked, `SecurityFinding.isSecretBearing` is over-masking.

| Line | Category | Requirement |
|---|---|---|
| `javaScriptEnabled = true` | WebView misuse | shown verbatim |
| `inferenceEndpoint` (OpenAI URL) | AI usage | shown verbatim |
| `appName` | (none) | no finding at all |

## 3. Fail-closed extraction (H-1) — `MalformedArchives/`

Cacomi must process these untrusted archives WITHOUT crashing, and must not
extract unbounded. The pre-extraction inventory is fail-open, so the
post-extraction byte ceiling is the backstop for the unverifiable cases.

| File | What it is | Expected behaviour |
|---|---|---|
| `valid-small.ipa` | A well-formed tiny zip (happy path) | extracts and scans normally |
| `truncated-central-dir.ipa` | Zip with a chopped central directory | clean error (corrupted/invalid), no crash, temp cleaned up |
| `not-a-zip.ipa` | Random bytes with a `.ipa` extension | clean error, no crash |
| `zip64-forced.apk` | A ZIP64 archive (inventory returns nil) | still scans; the post-extraction ceiling — not the fail-open inventory — is what bounds it |

Oversize / zip-bomb ceiling: shipping a real multi-GB bomb here is unsafe, so
it is validated by lowering the cap. To exercise the ceiling manually, set a
small `cacomi.archive.maxUncompressedBytes` override (Preferences) and scan an
archive whose extracted size exceeds it — Cacomi must reject it with an
"archive too large" error and remove the temp directory. The unit-level path
is covered by the extractor tests.

## 4. Detection coverage — `DetectionGaps/`

After the Tier 6 detector additions, most of these are now DETECTED (via
`UnsafePlatformAPIRule`, mapped to `dangerousCommand`). A couple remain
documented gaps. Updated status:

| File | Behaviour | Status |
|---|---|---|
| `DynamicLoadingAndScripts.swift` | `dlopen`/`dlsym` dynamic loading | DETECTED (medium, informational confidence) |
| `DynamicLoadingAndScripts.swift` | embedded-script `eval` / `new Function` | DETECTED |
| `DynamicLoadingAndScripts.swift` | `BGTaskScheduler` background abuse | gap (intentionally not flagged - too noisy per-line) |
| `AndroidDynamicAndBackground.kt` | `DexClassLoader` / `PathClassLoader` runtime class loading | DETECTED (high) |
| `AndroidDynamicAndBackground.kt` | reflection `getMethod` / `getDeclaredMethod` | DETECTED |
| `AndroidDynamicAndBackground.kt` | `System.load(path)` absolute native load | DETECTED |
| `AndroidDynamicAndBackground.kt` | `System.loadLibrary` (bundled native lib) | gap (intentionally not flagged - normal NDK usage) |
| `AndroidDynamicAndBackground.kt` | wake-lock / foreground-service abuse | gap |

Confidence note: `dlopen`/`dlsym`, reflection, and `eval` are reported at
LOW confidence, so they surface as Informational (review signals) rather
than inflating the actionable count. `DexClassLoader` is HIGH severity
(strong dynamic-payload signal).
