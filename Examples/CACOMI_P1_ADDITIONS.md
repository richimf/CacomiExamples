# Cacomi — Adiciones de cobertura (paridad con ValidationFixtures)

Casos **intencionalmente inseguros** agregados a los proyectos de ejemplo para que
Cacomi tenga positivos que detectar. Todos los valores de secretos son **FAKE /
no funcionales** y cada caso está anotado en el código con `CACOMI-EXPECT` (positivo)
o `CACOMI-NEGATIVE` / `// CACOMI-EXPECT: none` (control de falso positivo).

Base de comparación: `Cacomixtle/ValidationFixtures/EXPECTED-FINDINGS.md`.

## iOS — `BinaryExampleIPA/BadPracticesIPA` (archivos nuevos)

| Archivo | Categorías nuevas |
|---|---|
| `CacomiTestApp/Secrets/P1Secrets.swift` | Azure AD secret · Supabase URL · GitLab runner (`glrt-`) · basic-auth en URL · SMTP en URL · Twilio SID+token · SendGrid · bloque PEM (cert, low) · OAuth `client_secret` · OAuth implicit (`response_type=token`) · OAuth redirect inseguro (`http://`) · Bearer en request. Negativos: PKCE, redirect https, placeholder. |
| `CacomiTestApp/Injection/NSPredicateInjection.swift` | NSPredicate format-string injection (3 variantes). Negativos: predicado parametrizado `%@`, predicado constante. |
| `CacomiTestApp/Logging/ConditionalDebugLogs.swift` | Log sensible envuelto en `if` de runtime, en ternario, tras `guard`; tarjeta completa en log. Negativos: `#if DEBUG`, log no sensible. |

## Android — `BinaryExampleAPK/BadPracticesAppAndroid` (archivos nuevos)

| Archivo | Categorías nuevas |
|---|---|
| `app/src/main/java/.../secrets/P1Secrets.kt` | Azure secret · Supabase URL · GitLab runner · basic-auth en URL · SMTP en URL · Twilio · SendGrid · PEM cert · OAuth implicit/redirect inseguro/`client_secret` · literal que sobrevive al DEX. Negativos: PKCE, redirect https, placeholder. |
| `app/src/main/java/.../logs/ConditionalLogging.kt` | `Log.e(password)` en `if`, token en `when`, key tras `guard`, tarjeta en `Log.i`. Negativos: guardado con `BuildConfig.DEBUG`, log no sensible. |
| `app/src/main/java/.../crypto/MoreWeakCrypto.kt` | Clave/IV hardcodeados · RC4 · Blowfish/ECB · AES-CBC IV fijo · MD5 para password · `SecureRandom` con seed fija. Negativos: SHA-256, AES-GCM con nonce aleatorio. |
| `app/src/main/assets/migration.sql` | `GRANT ALL PRIVILEGES` (x2) · `DROP TABLE` · credencial en comentario · DDL dinámico. Negativos: `SELECT` parametrizado, GRANT de columna acotado. |
| `cacomi_dynamic_versions.gradle` *(fixture, NO aplicado al build)* | maven repo `http://` · versiones dinámicas `1.+`, `latest.release`, `[1.0,2.0)` · `-SNAPSHOT`. Negativos: repo https, versión fija. |

> `cacomi_dynamic_versions.gradle` no se llama `build.gradle`/`settings.gradle`, por lo
> que Gradle **no lo aplica** y no afecta la compilación; existe solo como fuente para
> las reglas de dependencias.

## Demos "limpias" — malas prácticas inyectadas (archivos nuevos)

| Archivo | Categorías |
|---|---|
| `SwiftExamples/CalculatorDemo/CalculatorDemo/InsecureExtras.swift` | Secrets (AWS/Stripe/Azure/basic-auth/PEM RSA) · UserDefaults token/password · file `.noFileProtection` · http cleartext · `URLSessionDelegate` accept-all · MD5 · AES-ECB · NSLog/print de token · log condicional · NSPredicate injection · WKWebView con JS. Varios negativos. |
| `ObjectiveCExamples/CalculatorOld/CalculatorOld/InsecureExtras.{h,m}` | Secrets (AWS/password/Bearer) · `CC_MD5` · DES/ECB (`CCCrypt`) · `NSUserDefaults` token · `NSURL` http cleartext · `NSLog` de credenciales · `strcpy`/`sprintf` (UnsafeCAPI). |

## OtherLanguages — fixtures ampliados (append)

| Archivo | Categorías nuevas |
|---|---|
| `OtherLanguages/multilanguage_examples/kotlin/KotlinSecurityAndUnusedFixture.kt` | `KotlinP1Secrets` (Azure/Supabase/GitLab/basic-auth/SMTP/OAuth) · token en `SharedPreferences` · `rawQuery` por concatenación · log condicional. Negativos: PKCE, `rawQuery` parametrizada. |
| `OtherLanguages/multilanguage_examples/swiftui/SwiftUISecurityAndUnusedFixture.swift` | `SwiftUIP1Secrets` (Azure/Supabase/GitLab/SMTP/OAuth) · NSPredicate injection · AES-ECB · file `.noFileProtection` · log condicional. Negativos: PKCE, predicado parametrizado. |

## Verificación

- Balance de llaves/paréntesis/corchetes verificado con lexer (comentarios y strings
  ignorados): **los 12 archivos quedan balanceados**.
- En este entorno no hay SDK de iOS/Android ni `swiftc`/`kotlinc`, así que la
  compilación completa se hace en tu máquina (Xcode / Gradle). Las firmas y APIs usadas
  son estándar de cada plataforma.
- Los archivos con checklist por número de línea (`CACOMI_TEST_CHECKLIST.md`) **no se
  editaron**; todo se agregó en archivos nuevos para no romper esas referencias.
