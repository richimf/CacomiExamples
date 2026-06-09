# BadPracticesAppAndroid — Banco de pruebas para Cacomi

App Android (Kotlin + algo de Java, Jetpack Compose, Gradle) con **malas prácticas
intencionales** para validar el analizador estático **Cacomi** sobre **fuente, binario
(APK/AAB) y config (AndroidManifest AXML)**.

> ⚠️ No es una app real. **Todos los secretos son DUMMY / de ejemplo**, no son
> credenciales reales. Cada caso está anotado en el código con
> `// BAD: ...  // CACOMI-EXPECT: <Regla>` o `// GOOD/NEGATIVO: ...  // CACOMI-EXPECT: none`.

## Cómo generar los binarios

```bash
cd BadPracticesAppAndroid
./gradlew assembleRelease   # genera el .apk en app/build/outputs/apk/release/
./gradlew bundleRelease     # genera el .aab en app/build/outputs/bundle/release/
```

`isMinifyEnabled = false` y `-dontobfuscate` se dejan a propósito para que **todo el
código y los literales sobrevivan al DEX** y el escaneo del binario los encuentre.

## Archivo → familia(s) Cacomi esperada(s)

| Archivo | Familia(s) | Qué prueba |
|---|---|---|
| `unused/UnusedCode.kt` | UnusedCode | fun/class/object/data class/enum/extension/val/const/prop privada + import no usados |
| `unused/UnusedNegatives.kt` | none (negativos) | `@Keep`, `@Inject` (DI), `@Composable`/`@Preview`, reflexión (`Class.forName`) |
| `jni/NativeBridge.kt` | none (negativo) | método JNI `external fun` (implementado en C) no debe marcarse |
| `components/LegacyActivity.kt` | none (negativo) | handler invocado solo por `android:onClick` desde XML |
| `logs/Logging.kt` | PrintAndLogs (+ negativos) | `Log.d/v/i/e`, `println`, `System.out` con datos sensibles; negativo `BuildConfig.DEBUG` / `isLoggable` |
| `logs/LegacyLogger.java` | PrintAndLogs | log + `System.out` en Java |
| `secrets/HardcodedSecrets.kt` | SecretPattern / HighEntropy / SaltHash | AWS/Google keys, password, client secret, Bearer, DB URL, webhook, PEM, salt/IV, literal que sobrevive al DEX |
| `secrets/SecretsJava.java` | SecretPattern / HighEntropy | secretos en Java |
| `secrets/KeystoreNegative.kt` | none (negativo) | clave generada en Android Keystore (no hardcodeada) |
| `crypto/WeakCrypto.kt` | WeakCipher / WeakKeyDerivation / SaltHash / WeakCrypto | MD5, SHA-1, DES, 3DES, AES/ECB, IV fijo, RSA/ECB, PBKDF2 1000 iter, `Random`, `SecureRandom` con seed; negativo SHA-256 checksum |
| `jwt/JwtUtil.kt` | JWTWeakSecret / JWTValidation | secreto `changeme`, comparación con `==`, acepta `alg:none` |
| `injection/SqlInjection.kt` | SQLRules | `rawQuery`/`execSQL` por concatenación; negativo parametrizado |
| `injection/CommandInjection.kt` | InjectionRules | `Runtime.exec` y `ProcessBuilder` con input |
| `injection/TaintSink.kt` + `components/DeepLinkActivity.kt` | InjectionRules/Taint | **taint cross-file**: fuente `getStringExtra`/`intent.data` → sinks SQL / `WebView.loadUrl` / ruta de archivo |
| `webview/WebViewMisuse.kt` | WebViewMisuse | `javaScriptEnabled`, `addJavascriptInterface`, `allowFileAccess`, `loadUrl("http://")`, `evaluateJavascript` con input |
| `network/TlsBypass.kt` | TLSTrustBypass | `X509TrustManager` que confía en todo, `HostnameVerifier` = true |
| `network/HttpClient.kt` | ResilienceAbsence / TLSTrustBypass | OkHttp sin `CertificatePinner`, endpoint cleartext |
| `storage/InsecureStorage.kt` | InsecureStorage / MobileMisuse | `MODE_WORLD_READABLE/WRITEABLE`, password/token en claro, almacenamiento externo, portapapeles, `StrictMode.permitAll()` |
| `resilience/Resilience.kt` | ResilienceAbsence / ResilienceFlag | sin pinning, sin root detection, `debugMenuEnabled = true` |
| `privacy/PiiData.kt` | PII | email/teléfono/SSN/IBAN/tarjeta de ejemplo |
| `trackers/TrackersAndAi.kt` | TrackerDetection / AIDiscovery | SDKs tracker (Facebook/Adjust/Firebase) + endpoint OpenAI con api_key |
| `masvs/MasvsConfig.kt` | MobileMisuse | introspección/playground GraphQL habilitados |
| `customrules/CustomRules.kt` | CustomRule | token `ACME_[A-Z0-9]{32}` + API prohibida `LegacyAnalytics.track(...)` |
| `components/Services.kt`, `ExportedReceiver.kt`, `ExportedProvider.kt`, `ComponentMisuse.kt` | AndroidComponentMisuse | componentes exported sin permiso, `PendingIntent` mutable/flags 0, `RECEIVER_EXPORTED`, broadcast sin permiso |
| `AndroidManifest.xml` | AndroidManifest / AndroidComponentMisuse / PrivacyPermission / NetworkSecurityConfig | exported sin permiso, `debuggable`, `allowBackup`, `testOnly`, `usesCleartextTraffic`, App Link sin `autoVerify`, permisos peligrosos, `QUERY_ALL_PACKAGES`, meta-data secreta |
| `res/xml/network_security_config.xml` | NetworkSecurityConfig / TLSTrustBypass | cleartext, trust-anchors de usuario, `debug-overrides` |
| `res/values/strings.xml` | SecretPattern / MobileMisuse / CustomRule | secretos, config GraphQL, token ACME |
| `assets/Config.json` | SecretPattern / HighEntropy | secretos + PEM en asset (sobrevive al APK) |
| `gradle.properties` | SecretPattern | secretos en propiedades de build |
| `app/build.gradle.kts` | SecretPattern / OSV-SCA / ProGuardRule | `BuildConfigField` con secreto, dep vulnerable, R8 off |
| `proguard-rules.pro` | ProGuardRule | `-dontobfuscate`, `-keep class ** { *; }` |

## Paridad con el banco iOS (BinaryExampleIPA)

Equivalentes Android añadidos para igualar los detectores del proyecto iOS:

| Archivo Android | Detector | Equivalente iOS |
|---|---|---|
| `network/AuthSession.kt` | AuthSessionRule | `Network/AuthSession.swift` (token en URL, sesión sin expiry, cookie sin flags; negativo header+expiry) |
| `platform/DangerousApis.kt` | UnsafePlatformAPIRule / ResilienceFlagRule / SecretPattern | `DangerousAPIs.swift` + `Resilience/AntiTampering.swift` (deserialización insegura, path traversal, `DexClassLoader`, reflexión sobre input, abrir URL sin validar, WebView debug, flags inseguros, secretos por regex) |
| `ai/AiUsage.kt` | AIDiscoveryRule | `Privacy/AIUsage.swift` (OpenAI + Anthropic + Gemini + modelo on-device TFLite/ML Kit) |
| `cpp/unsafe_capi.c`, `cpp/unsafe_buffers.cpp`, `cpp/native-lib.c` + `cpp/CMakeLists.txt` | UnsafeCAPIRule / UnusedCode (C++) | `ObjC/UnsafeCAPI.m`, `Cpp/UnsafeBuffers.cpp` (`strcpy`/`sprintf`/`gets`/`memcpy`/`system`/`rand`) — compilado en `libbadpractices.so` |
| `assets/queries.sql` | SQLRules | `Injection/queries.sql` (GRANT ALL, EXEC con concatenación, DDL dinámico; negativo parametrizado) |
| `assets/credentials.env` | SecretPattern / HighEntropy | `credentials.env` (secretos en formato KEY=VALUE; negativo feature flag) |
| `assets/secrets.json` | SecretPattern / HighEntropy | `secrets.json` (claves Stripe/GitHub/Slack/Twilio/SendGrid/PEM; negativos UUID y git SHA) |
| `res/raw/config.xml` | SecretPattern | `config.xml` (secretos en XML; negativo feature flag) |
| `injection/SqlInjection.kt` (`searchFromInput`) | TaintAnalyzer (intra-archivo) | `Injection/SQLInjection.swift` (fuente `EditText` → sink `rawQuery`) |
| `injection/TaintSink.kt` (`runSafe`) | none (negativo CrossFileTaint) | `Taint/TaintSinkConsumer.swift` (constante sin fuente) |
| `privacy/PiiData.kt` (negativos) | none | `PII/PIIData.swift` (tarjeta que falla Luhn, SSN reservado `000-..`) |
| `secrets/HardcodedSecrets.kt` (negativos) | none | `Secrets/HardcodedSecrets.swift` (UUID y commit SHA no son secretos) |
| `trackers/TrackersAndAi.kt` (ampliado) | TrackerDetection | `Privacy/Trackers.swift` (Amplitude, AppsFlyer, Meta pixel) |

### ⚠️ Requisito NDK

El código nativo (`UnsafeCAPIRule`) se compila con **NDK + CMake**. Android Studio
ofrece instalarlos automáticamente al sincronizar (prompt *"Install NDK and sync"*).
Si prefieres un build sin nativo, elimina los bloques `externalNativeBuild`/`ndk` de
`app/build.gradle.kts`; los `.c`/`.cpp` seguirán siendo analizables como fuente.
El método JNI `NativeBridge.nativeChecksum` se implementa en `cpp/native-lib.c`.

## Dependencias añadidas

- `com.squareup.okhttp3:okhttp:4.12.0` — red sin pinning (ResilienceAbsence / TLS).
- `commons-collections:commons-collections:3.2.1` — **CVE-2015-7501** conocida (OSV/SCA).
- `javax.inject:javax.inject:1` — anotación `@Inject` para el negativo de DI.

## Nota sobre compilación

El proyecto mantiene la estructura y plugins originales de Android Studio (AGP 9.2.1).
Cambios de build: se habilitó `buildConfig`, se añadieron 3 dependencias y reglas de
release. No se modificó nada que rompa el grafo de plugins existente. Genera **APK y AAB**
para cubrir los hallazgos que solo se ven en el binario (manifest AXML + literales en DEX).
