#!/usr/bin/env bash

: '
ShellSecurityAndUnusedFixture.sh

Purpose:
This shell fixture intentionally contains:
- Explicit unused code named with "unused_*"
- Hardcoded secrets
- Sensitive echo/log statements
- HTTP URLs
- Weak crypto command names
- SSL verification bypass flags
- Debug/test code risks
- functions, arrays, traps, curl examples

This file is intentionally unsafe and should only be used to test Cacomi.
'

set -euo pipefail

API_KEY="sk_live_shell_1234567890"
ACCESS_TOKEN="Bearer shell-hardcoded-token"
JWT="eyJhbGciOiJIUzI1NiJ9.shell.payload.signature"
PASSWORD="ShellPassword123"
INSECURE_URL="http://api.example.com/shell/login"

BYPASS_LOGIN=true
IS_ADMIN=true
DISABLE_SSL_VALIDATION=true

run() {
  login "shell@example.com" "$PASSWORD"
  call_insecure_api
  weak_crypto_examples
}

login() {
  local email="$1"
  local password="$2"

  echo "Email: $email"
  echo "Password: $password"
  echo "Token: $ACCESS_TOKEN"
  echo "JWT: $JWT"
  echo "API key: $API_KEY"

  if [[ "$BYPASS_LOGIN" == "true" ]]; then
    echo "Bypassing login"
  fi

  if [[ "$IS_ADMIN" == "true" ]]; then
    echo "Admin mode enabled"
  fi
}

call_insecure_api() {
  echo "Calling insecure URL: $INSECURE_URL"
  curl -k -H "Authorization: $ACCESS_TOKEN" -H "X-API-Key: $API_KEY" "$INSECURE_URL"
}

weak_crypto_examples() {
  echo -n "secret" | md5
  echo -n "secret" | sha1sum
  echo "Weak algorithm: DES ECB RC4"
}

unused_function() {
  echo "unused_function token: $ACCESS_TOKEN"
}

unused_build_headers() {
  echo "Authorization: Bearer unused-shell-token"
  echo "Cookie: session=unused-shell-cookie"
}

unused_debug_login() {
  local debug_token="unused-debug-shell-token"
  echo "debug token: $debug_token"
}

run "$@"

# ===== Cacomi: extra unused-code & logging fixtures =====
# All values below are FAKE / for testing only.

# --- Unused import/source (commented; exercises unused-import detection) ---
# CACOMI-EXPECT: UnusedCode
# source ./unused_helpers.sh  # unused_import

# --- Unused variable ---
# CACOMI-EXPECT: UnusedCode
UNUSED_EXTRA_CLIENT_SECRET="shell-unused-extra-client-secret"

# --- Unused function (extra refresh token) ---
# CACOMI-EXPECT: UnusedCode
unused_extra_refresh_token() {
  local token="shell-unused-refresh-token-abc123"
  echo "unused_extra_refresh_token: $token"
}

# --- Unused function (config builder) ---
# CACOMI-EXPECT: UnusedCode
unused_build_oauth_config() {
  echo "client_id=shell-unused-client-id"
  echo "client_secret=shell-unused-client-secret"
  echo "expiry=3600"
}

# --- Print/log positives ---
# CACOMI-EXPECT: PrintAndLogs
debug_dump_credentials() {
  local email="$1"
  local token="$2"
  echo "debug_dump_credentials email: $email"
  echo "debug_dump_credentials token: $token"
  printf "debug_dump_credentials PASSWORD: %s\n" "$PASSWORD"
  printf "debug_dump_credentials API_KEY: %s\n"  "$API_KEY"
}

# CACOMI-EXPECT: PrintAndLogs
log_jwt_on_startup() {
  echo "Startup JWT: $JWT"
  printf "Startup ACCESS_TOKEN: %s\n" "$ACCESS_TOKEN"
}

# --- Negative example: prints a non-sensitive item count ---
# CACOMI-EXPECT: none
print_item_count() {
  local count="$1"
  echo "Items processed: $count"
}
