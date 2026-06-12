# PhaseB Mach-O Fixtures

Tiny synthetic arm64 Mach-O dynamic library headers hand-crafted for static binary-protection analysis. They are **not runnable libraries** — each is a minimal Mach-O header that carries only the load commands needed to exercise one specific binary-protection signal under OWASP MASVS **M7 (Insufficient Binary Protections)**.

## Fixture table

| File | PIE | Stack guard / fortified libc | Dangerous imports | LC_RPATH | Expected Cacomi finding | Notes |
|---|---|---|---|---|---|---|
| `hardened_macho.dylib` | Yes | `___stack_chk_fail` + `___strcpy_chk` | None | None | **Negative / hardened** — no findings expected | Reference "clean" binary; all protections present |
| `insecure_funcs_macho.dylib` | Yes | None | `_strcpy`, `_system` | None | **M7 high** — insecure libc function usage (`strcpy`, `system`) | Exercises insecure-function-import detection |
| `no_pie_macho.dylib` | **No** | None | None | None | **M7 high** — PIE (ASLR) flag missing | Exercises missing-PIE / missing-ASLR detection |
| `rpath_hijack_macho.dylib` | Yes | None | None | `/Users/dev/DerivedData/Build/Products` | **M7 medium** — absolute developer `LC_RPATH` shipped in binary | Exercises rpath-hijack / debug-path-leak detection |

## Signal details

### hardened_macho.dylib — hardened (negative example)
- `MH_PIE` flag set in Mach-O header → ASLR enabled.
- Imports `___stack_chk_fail` (stack canary runtime support) and `___strcpy_chk` (fortified `strcpy` from `libsystem_platform`) — both indicate compiler hardening (`-fstack-protector`, `_FORTIFY_SOURCE`).
- No dangerous libc symbols, no suspicious rpath entries.
- **Expected result:** Cacomi emits no binary-protection findings — this is the baseline hardened binary.

### insecure_funcs_macho.dylib — insecure libc imports
- `MH_PIE` flag set (PIE is present so that PIE-detection does not trigger).
- Imports `_strcpy` (unsafe, no bounds checking) and `_system` (allows arbitrary shell command execution — unavailable on iOS but detectable in third-party SDKs).
- **Expected result:** Cacomi flags **M7 high** — dangerous function imports detected; recommend replacing `strcpy` with `strlcpy`/`strncpy` and removing `system`.

### no_pie_macho.dylib — missing PIE / ASLR
- `MH_PIE` flag **not set** → binary loads at a fixed base address, defeating ASLR.
- No other imports or load commands beyond the bare Mach-O header.
- **Expected result:** Cacomi flags **M7 high** — PIE (position-independent executable) flag absent; binary is not ASLR-compatible.

### rpath_hijack_macho.dylib — developer rpath leak
- `MH_PIE` flag set.
- Contains an `LC_RPATH` entry pointing at an absolute developer-machine path: `/Users/dev/DerivedData/Build/Products`.
- This path does not exist on end-user devices; an attacker with local access can place a malicious dylib at that path to achieve dylib hijacking.
- **Expected result:** Cacomi flags **M7 medium** — absolute `LC_RPATH` referencing a developer build directory found in shipped binary; path should be removed or replaced with `@executable_path`-relative rpath.

## Usage

These files are consumed by Cacomi's Mach-O binary-protection analyser during a project or IPA bundle scan. They are also copied into `BadPracticesIPA/EmbeddedBinaries/` so that a single scan of the example IPA exercises all four signals. See that folder's README for integration details.
