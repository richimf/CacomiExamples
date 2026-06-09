# CACOMI Test Checklist

> Auto-generated companion to `CacomiTestApp/`. One row per `CACOMI-EXPECT`.
> Negative controls live in section 2.
> Severities reflect the marker on the source line, not Cacomi's own scoring.

## 1. Positive cases (CACOMI-EXPECT)

| Archivo | Regla | Severidad | Línea | Detectado |
|---|---|---|---|---|
| CacomiTestApp/CacomiTestApp-Info.plist | SecretPatternRule | high | 5 | [ ] |
| CacomiTestApp/CacomiTestApp-Info.plist | insecureHTTP | critical | 9 | [ ] |
| CacomiTestApp/CacomiTestApp-Info.plist | insecureHTTP | high | 18 | [ ] |
| CacomiTestApp/CacomiTestApp-Info.plist | UnsafePlatformAPIRule | medium | 29 | [ ] |
| CacomiTestApp/CacomiTestApp.entitlements | ResilienceFlagRule | high | 5 | [ ] |
| CacomiTestApp/CacomiTestApp.entitlements | ResilienceFlagRule | medium | 12 | [ ] |
| CacomiTestApp/CacomiTestApp.entitlements | ResilienceFlagRule | high | 16 | [ ] |
| CacomiTestApp/Cpp/Engine.cpp | UnusedCode | low | 12 | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | low | 16 | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | low | 24 | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | low | 32 | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | low | 35 | [ ] |
| CacomiTestApp/Cpp/UnsafeBuffers.cpp | UnsafeCAPIRule | critical | 14 | [ ] |
| CacomiTestApp/Cpp/UnsafeBuffers.cpp | UnsafeCAPIRule | critical | 18 | [ ] |
| CacomiTestApp/Cpp/UnsafeBuffers.cpp | UnsafeCAPIRule | high | 22 | [ ] |
| CacomiTestApp/Cpp/UnsafeBuffers.cpp | UnsafeCAPIRule | critical | 25 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCipherRule | high | 22 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCipherRule | high | 45 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCipherRule | high | 68 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCipherRule | high | 91 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCryptoExtensions | high | 112 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCryptoExtensions | high | 118 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCryptoExtensions | high | 127 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCryptoExtensions | high | 136 | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakKeyDerivation | high | 147 | [ ] |
| CacomiTestApp/Crypto/JWTHandling.swift | JWTWeakSecretRule | high | 12 | [ ] |
| CacomiTestApp/Crypto/JWTHandling.swift | JWTWeakSecretRule | high | 15 | [ ] |
| CacomiTestApp/Crypto/JWTHandling.swift | JWTValidationRule | critical | 24 | [ ] |
| CacomiTestApp/Crypto/JWTHandling.swift | JWTValidationRule | high | 30 | [ ] |
| CacomiTestApp/Crypto/JWTHandling.swift | JWTValidationRule | critical | 38 | [ ] |
| CacomiTestApp/Crypto/SaltAndHash.swift | SaltHashRule | high | 15 | [ ] |
| CacomiTestApp/Crypto/SaltAndHash.swift | SaltHashRule | high | 20 | [ ] |
| CacomiTestApp/Crypto/SaltAndHash.swift | SaltHashRule | high | 26 | [ ] |
| CacomiTestApp/Injection/CommandInjection.swift | InjectionRules | critical | 13 | [ ] |
| CacomiTestApp/Injection/CommandInjection.swift | InjectionRules | critical | 27 | [ ] |
| CacomiTestApp/Injection/SQLInjection.swift | InjectionRules | critical | 23 | [ ] |
| CacomiTestApp/Injection/SQLInjection.swift | TaintAnalyzer | high | 25 | [ ] |
| CacomiTestApp/Injection/SQLInjection.swift | InjectionRules | critical | 30 | [ ] |
| CacomiTestApp/Injection/queries.sql | SQLRules | critical | 4 | [ ] |
| CacomiTestApp/Injection/queries.sql | SQLRules | critical | 7 | [ ] |
| CacomiTestApp/Injection/queries.sql | SQLRules | high | 10 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | low | 17 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | low | 20 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | medium | 23 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | medium | 26 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | medium | 29 | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | critical | 32 | [ ] |
| CacomiTestApp/Network/AuthSession.swift | AuthSessionRule | high | 12 | [ ] |
| CacomiTestApp/Network/AuthSession.swift | AuthSessionRule | high | 16 | [ ] |
| CacomiTestApp/Network/AuthSession.swift | AuthSessionRule | high | 21 | [ ] |
| CacomiTestApp/Network/InsecureEndpoints.swift | insecureHTTP | high | 11 | [ ] |
| CacomiTestApp/Network/InsecureEndpoints.swift | insecureHTTP | high | 14 | [ ] |
| CacomiTestApp/Network/InsecureEndpoints.swift | insecureHTTP | critical | 17 | [ ] |
| CacomiTestApp/Network/TLSTrust.swift | TLSTrustBypassRule | critical | 18 | [ ] |
| CacomiTestApp/Network/TLSTrust.swift | TLSTrustBypassRule | high | 27 | [ ] |
| CacomiTestApp/ObjC/LegacyCrypto.m | SecretPatternRule | high | 13 | [ ] |
| CacomiTestApp/ObjC/LegacyCrypto.m | WeakCryptoExtensions | high | 19 | [ ] |
| CacomiTestApp/ObjC/LegacyCrypto.m | LogParser | critical | 30 | [ ] |
| CacomiTestApp/ObjC/UnsafeCAPI.m | UnsafeCAPIRule | critical | 15 | [ ] |
| CacomiTestApp/ObjC/UnsafeCAPI.m | UnsafeCAPIRule | critical | 19 | [ ] |
| CacomiTestApp/ObjC/UnsafeCAPI.m | UnsafeCAPIRule | critical | 23 | [ ] |
| CacomiTestApp/ObjC/UnsafeCAPI.m | UnsafeCAPIRule | critical | 26 | [ ] |
| CacomiTestApp/ObjC/UnsafeCAPI.m | UnsafeCAPIRule | high | 30 | [ ] |
| CacomiTestApp/PII/PIIData.swift | PIIPatternRule | critical | 12 | [ ] |
| CacomiTestApp/PII/PIIData.swift | PIIPatternRule | high | 15 | [ ] |
| CacomiTestApp/PII/PIIData.swift | PIIPatternRule | high | 18 | [ ] |
| CacomiTestApp/Privacy/AIUsage.swift | AIDiscoveryRule | info | 9 | [ ] |
| CacomiTestApp/Privacy/AIUsage.swift | AIDiscoveryRule | info | 11 | [ ] |
| CacomiTestApp/Privacy/AIUsage.swift | AIDiscoveryRule | info | 16 | [ ] |
| CacomiTestApp/Privacy/AIUsage.swift | AIDiscoveryRule | high | 19 | [ ] |
| CacomiTestApp/Privacy/AIUsage.swift | AIDiscoveryRule | high | 22 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | medium | 12 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | medium | 17 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | medium | 22 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | medium | 27 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | medium | 32 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | low | 38 | [ ] |
| CacomiTestApp/Privacy/Trackers.swift | TrackerDetectionRule | low | 40 | [ ] |
| CacomiTestApp/Resilience/AntiTampering.swift | ResilienceFlagRule | medium | 13 | [ ] |
| CacomiTestApp/Resilience/AntiTampering.swift | ResilienceFlagRule | medium | 18 | [ ] |
| CacomiTestApp/Resilience/AntiTampering.swift | UnsafePlatformAPIRule | high | 25 | [ ] |
| CacomiTestApp/Resilience/AntiTampering.swift | UnsafePlatformAPIRule | high | 32 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 13 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 16 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 19 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 22 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 25 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 28 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | critical | 31 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 39 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | high | 42 | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | HighEntropyStringRule | medium | 45 | [ ] |
| CacomiTestApp/Secrets/SecretsInConfig.xcconfig | SecretPatternRule | high | 2 | [ ] |
| CacomiTestApp/Secrets/SecretsInConfig.xcconfig | SecretPatternRule | high | 5 | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | InsecureStorageRule | high | 15 | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | InsecureStorageRule | high | 17 | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | InsecureStorageRule | high | 19 | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | MobileMisuse | high | 23 | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | MobileMisuse | high | 32 | [ ] |
| CacomiTestApp/Taint/TaintSinkConsumer.swift | CrossFileTaint | high | 15 | [ ] |
| CacomiTestApp/Taint/TaintSinkConsumer.swift | CrossFileTaint | high | 20 | [ ] |
| CacomiTestApp/Taint/TaintSourceHelper.swift | CrossFileTaint | high | 15 | [ ] |
| CacomiTestApp/UnusedCode/UnusedSwift.swift | UnusedCode | low | 10 | [ ] |
| CacomiTestApp/UnusedCode/UnusedSwift.swift | UnusedCode | low | 13 | [ ] |
| CacomiTestApp/UnusedCode/UnusedSwift.swift | UnusedCode | low | 19 | [ ] |
| CacomiTestApp/UnusedCode/UnusedSwift.swift | UnusedCode | low | 25 | [ ] |
| CacomiTestApp/UnusedCode/UnusedSwift.swift | UnusedCode | low | 33 | [ ] |
| CacomiTestApp/WebViews/WebViewMisuse.swift | WebViewMisuseExtrasRule | high | 15 | [ ] |
| CacomiTestApp/WebViews/WebViewMisuse.swift | WebViewMisuseExtrasRule | high | 17 | [ ] |
| CacomiTestApp/WebViews/WebViewMisuse.swift | MobileMisuseRules | high | 20 | [ ] |

**Total positivos: 104**

## 2. Negative controls (CACOMI-NEGATIVE)

| Archivo | Regla | Línea | Razón | No-detectado |
|---|---|---|---|---|
| CacomiTestApp/CacomiTestApp-Info.plist | PrivacyUsage | 43 | legitimate usage description | [ ] |
| CacomiTestApp/CacomiTestApp-Info.plist | PrivacyUsage | 46 | legitimate usage description | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | 38 | comments/strings must not produce symbols | [ ] |
| CacomiTestApp/Cpp/Engine.hpp | UnusedCode | 51 | override required by base interface | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCipherRule | 162 | AES-GCM is authenticated, strong cipher | [ ] |
| CacomiTestApp/Crypto/CacomiWeakCrypto.swift | WeakCryptoExtensions | 169 | SHA-256 is acceptable | [ ] |
| CacomiTestApp/Crypto/SaltAndHash.swift | SaltHashRule | 32 | PBKDF2 with secure random salt and high rounds | [ ] |
| CacomiTestApp/Injection/CommandInjection.swift | InjectionRules | 32 | fixed command with no untrusted input | [ ] |
| CacomiTestApp/Injection/SQLInjection.swift | InjectionRules | 36 | query uses placeholders with bound parameters | [ ] |
| CacomiTestApp/Injection/queries.sql | SQLRules | 13 | read-only parameterized query | [ ] |
| CacomiTestApp/Logging/DebugLogs.swift | LogParser | 38 | log already wrapped in #if DEBUG | [ ] |
| CacomiTestApp/Network/AuthSession.swift | AuthSessionRule | 33 | token in Authorization header + session has expiry | [ ] |
| CacomiTestApp/Network/InsecureEndpoints.swift | insecureHTTP | 20 | production HTTPS endpoint, inventory-only | [ ] |
| CacomiTestApp/Network/TLSTrust.swift | TLSTrustBypassRule | 39 | validates trust with pinning before accepting | [ ] |
| CacomiTestApp/PII/PIIData.swift | PIIPatternRule | 21 | 16-digit number that fails Luhn check | [ ] |
| CacomiTestApp/PII/PIIData.swift | PIIPatternRule | 24 | reserved SSN area (000-..) is not a real SSN | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | 48 | plain UUID is not a secret | [ ] |
| CacomiTestApp/Secrets/HardcodedSecrets.swift | SecretPatternRule | 51 | public git commit SHA is not a secret | [ ] |
| CacomiTestApp/Secrets/SecretsInConfig.xcconfig | SecretPatternRule | 8 | feature flag is not a secret | [ ] |
| CacomiTestApp/Storage/CacomiInsecureStorage.swift | InsecureStorageRule | 41 | non-sensitive UI preference in UserDefaults | [ ] |
| CacomiTestApp/Taint/TaintSinkConsumer.swift | CrossFileTaint | 25 | helper has no source so sink should not be tainted | [ ] |
| CacomiTestApp/Taint/TaintSourceHelper.swift | CrossFileTaint | 19 | helper returns a constant, does not touch a source | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 15 | @IBAction is invoked via Interface Builder | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 18 | @IBOutlet is wired in IB | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 26 | protocol method invoked by UIKit | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 29 | method registered via #selector | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 34 | invoked dynamically by UIKit through selector | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 38 | SwiftUI #Preview keeps the view alive at design-time | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 46 | Codable type referenced by JSONDecoder via reflection | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 51 | CodingKeys used by Codable machinery via reflection | [ ] |
| CacomiTestApp/UnusedCode/DynamicallyUsed.swift | UnusedCode | 58 | AppDelegate method invoked by UIApplication at launch | [ ] |
| CacomiTestApp/WebViews/WebViewMisuse.swift | WebViewMisuseExtrasRule | 28 | static HTTPS request, no JS bridge, no file access | [ ] |

**Total controles negativos: 32**

## 3. Coverage por detector

| Detector | Casos positivos | Casos negativos |
|---|---:|---:|
| SecretPatternRule           | 14 | 3 |
| HighEntropyStringRule       |  1 | 0 |
| WeakCipherRule              |  4 | 1 |
| WeakCryptoExtensions        |  5 | 1 |
| WeakKeyDerivation           |  1 | 0 |
| SaltHashRule                |  3 | 1 |
| JWTValidationRule           |  3 | 0 |
| JWTWeakSecretRule           |  2 | 0 |
| TLSTrustBypassRule          |  2 | 1 |
| insecureHTTP                |  5 | 1 |
| AuthSessionRule             |  3 | 1 |
| InsecureStorageRule         |  3 | 1 |
| MobileMisuse                |  2 | 0 |
| WebViewMisuseExtrasRule     |  2 | 1 |
| MobileMisuseRules           |  1 | 0 |
| InjectionRules              |  4 | 2 |
| TaintAnalyzer               |  1 | 0 |
| SQLRules                    |  3 | 1 |
| CrossFileTaint              |  3 | 2 |
| PIIPatternRule              |  3 | 2 |
| TrackerDetectionRule        |  7 | 0 |
| AIDiscoveryRule             |  5 | 0 |
| LogParser                   |  7 | 1 |
| ResilienceFlagRule          |  5 | 0 |
| UnsafePlatformAPIRule       |  3 | 0 |
| UnusedCode                  | 10 | 9 |
| UnsafeCAPIRule              |  9 | 0 |
| PrivacyUsage (inventory)    |  0 | 2 |

## 4. Notas operativas

- El proyecto **compila** para iOS Simulator (verificado con `BuildProject`).
- `system(3)` no está disponible en iOS, por lo que tres casos
  (`CommandInjection.swift:27`, `Cpp/UnsafeBuffers.cpp:25`,
  `ObjC/UnsafeCAPI.m:26`) se convierten en literales `"system(..."`
  embebidos en el binario. Sirven igualmente como sink reconocible
  textualmente; si Cacomi exige llamada en grafo de control, considéralos
  candidatos a falso negativo esperado.
- Los imports de SDKs de tracking en `Trackers.swift` se protegen con
  `#if canImport(...)` ya que las dependencias no están enlazadas. El
  detector basado en string del nombre del módulo sí los encontrará.
- El bridging header se entrega en `ObjC/CacomiTestApp-Bridging-Header.h`.
  Si el target no tiene `SWIFT_OBJC_BRIDGING_HEADER` configurado, Obj-C
  no es invocable desde Swift, pero los archivos siguen entrando a la
  fase *Compile Sources* y por tanto son analizables.
- `CrossFileTaint` espera **confianza media** (la conexión source→sink
  cruza archivos sin anotaciones explícitas).
- `TaintAnalyzer` (intra-file) y `InjectionRules` se solapan en
  `SQLInjection.swift`; ambas filas están listadas para verificar que
  cada detector reporta por separado.
