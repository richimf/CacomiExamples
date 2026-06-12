# EmbeddedBinaries

This folder contains copies of the four synthetic Mach-O fixtures from
`Examples/BinaryExampleIPA/PhaseB_MachO_fixtures/`.

They are placed here so that a single Cacomi scan of the `BadPracticesIPA` app
bundle or project folder discovers and analyses all M7 binary-protection test
cases without requiring a separate scan of the PhaseB directory.

## Purpose

These binaries simulate **embedded or third-party frameworks** that an app
ships inside its IPA. Real-world IPAs routinely bundle third-party `.dylib` /
`.framework` files; Cacomi must scan each embedded binary independently and
report binary-protection findings per-binary.

## Files and expected findings

| File | M7 signal exercised | Expected finding |
|---|---|---|
| `hardened_macho.dylib` | All protections present | Negative — no findings (hardened reference binary) |
| `insecure_funcs_macho.dylib` | Dangerous libc imports (`_strcpy`, `_system`) | M7 high — insecure function imports |
| `no_pie_macho.dylib` | PIE / ASLR flag absent | M7 high — missing PIE |
| `rpath_hijack_macho.dylib` | Absolute developer `LC_RPATH` | M7 medium — rpath hijack / debug path leak |

For full signal descriptions and the construction rationale for each fixture,
see [`PhaseB_MachO_fixtures/README.md`](../../../../PhaseB_MachO_fixtures/README.md).

## Notes

- These are **tiny synthetic Mach-O headers**, not runnable libraries.
- Do not link against them; they exist solely as scanner test inputs.
- The originals in `PhaseB_MachO_fixtures/` are kept intact — these are copies.
- Adding a new fixture: copy it here and document it in both README files.
