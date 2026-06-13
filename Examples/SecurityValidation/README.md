# Security Validation Pack

Fixtures for validating Cacomi's secret **masking** and untrusted-file
**hardening**, and for documenting current **detection gaps**. Added
alongside the audit fixes for CR-1 (no full secrets in UI/clipboard), H-4
(stronger masking), and H-1 (fail-closed archive extraction).

All secret values are FAKE and exist only to exercise the scanner. None are
real credentials.

## Layout

```
SecurityValidation/
  Masking/
    SecretsMaskingShowcase.swift      # secrets that must render MASKED (CR-1/H-4)
    NonSecretVerbatimControls.swift   # non-secrets that must render VERBATIM
  MalformedArchives/
    valid-small.ipa                   # happy-path control
    truncated-central-dir.ipa         # chopped central directory
    not-a-zip.ipa                     # random bytes, .ipa extension
    zip64-forced.apk                  # ZIP64 (inventory returns nil)
  DetectionGaps/
    DynamicLoadingAndScripts.swift    # dlopen / embedded script / background abuse (not detected yet)
    AndroidDynamicAndBackground.kt    # DexClassLoader / reflection / native load (not detected yet)
  EXPECTED.md                         # ground truth for everything above
```

## How to run

- Source masking / gaps: open Cacomi, **Analyze Project**, and select the
  `Masking/` or `DetectionGaps/` folder (or the whole `SecurityValidation`
  folder). Compare findings and their previews against `EXPECTED.md`.
- Malformed archives: drop each file in `MalformedArchives/` onto Cacomi as a
  binary. Confirm it is handled without a crash and per the table in
  `EXPECTED.md`.

## What this validates

- **CR-1 / H-4** — every detected secret is masked in the inline preview, the
  clipboard, and exported reports; the verbatim value is reachable only via an
  explicit reveal. Non-secret findings stay verbatim (negative control).
- **H-1** — malformed / ZIP64 / non-zip inputs are handled without crashing,
  temp directories are cleaned up, and extraction is bounded by the
  post-extraction byte ceiling rather than failing open.
- **Detection gaps** — behaviours not yet detected are captured so they can
  become positive regression cases when the detectors land.
