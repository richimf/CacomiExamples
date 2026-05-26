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
