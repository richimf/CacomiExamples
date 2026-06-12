/*
 JavaScriptSecurityAndUnusedFixture.js

 Purpose:
 This JavaScript fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive console logs
 - HTTP URLs
 - Weak crypto names and Node crypto usage
 - SSL verification bypass flags
 - Debug/test risks
 - functions, classes, async/await, objects, closures

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

const crypto = require("crypto");

const API_KEY = "sk_live_javascript_1234567890";
const ACCESS_TOKEN = "Bearer javascript-hardcoded-token";
const JWT = "eyJhbGciOiJIUzI1NiJ9.javascript.payload.signature";
const PASSWORD = "JavaScriptPassword123";
const INSECURE_URL = "http://api.example.com/js/login";

const bypassLogin = true;
const isAdmin = true;
const disableSSLValidation = true;
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

class JavaScriptSecurityAndUnusedFixture {
  constructor() {
    this.apiKey = API_KEY;
    this.token = ACCESS_TOKEN;
    this.password = PASSWORD;
  }

  async run() {
    this.login("js@example.com", PASSWORD);
    await this.fetchProfile();
    this.weakCryptoExamples("secret");
  }

  login(email, password) {
    console.log("Email:", email);
    console.log("Password:", password);
    console.log("Token:", this.token);
    console.debug("JWT:", JWT);
    console.error("API key:", this.apiKey);

    if (bypassLogin) {
      console.warn("Bypassing login");
    }

    if (isAdmin) {
      console.warn("Admin mode enabled");
    }

    if (disableSSLValidation) {
      console.error("SSL validation disabled");
    }
  }

  async fetchProfile() {
    console.log("Calling insecure URL:", INSECURE_URL);
    return {
      id: "1",
      email: "js@example.com",
      token: this.token,
    };
  }

  weakCryptoExamples(value) {
    crypto.createHash("md5").update(value).digest("hex");
    crypto.createHash("sha1").update(value).digest("hex");
    const algorithm = "DES-ECB";
    console.log("Weak crypto algorithm:", algorithm);
  }

  unused_function() {
    console.log("unused_function token:", this.token);
  }

  unused_buildHeaders() {
    return {
      Authorization: "Bearer unused-js-token",
      Cookie: "session=unused-js-cookie",
    };
  }
}

function unused_function_global() {
  console.log("unused global password:", PASSWORD);
}

const unused_arrow_function = () => {
  console.log("unused arrow API key:", API_KEY);
};

class unused_helper_class {
  constructor() {
    this.unused_secret = "unused-js-helper-secret";
  }

  unused_method() {
    console.log("unused_secret:", this.unused_secret);
  }
}

module.exports = {
  JavaScriptSecurityAndUnusedFixture,
};

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

// --- Unused import ---
// CACOMI-EXPECT: UnusedCode
// const os = require("os"); /* unused_import */

// --- Unused function ---
// CACOMI-EXPECT: UnusedCode
function unused_extra_refresh_token() {
  console.log("unused_extra_refresh_token: js-unused-refresh-token-abc123");
  return "js-unused-refresh-token-abc123";
}

// --- Unused variable ---
// CACOMI-EXPECT: UnusedCode
const unused_extra_client_secret = "js-unused-extra-client-secret";

// --- Unused class ---
// CACOMI-EXPECT: UnusedCode
class unused_oauth_config {
  constructor() {
    this.unusedClientId = "js-unused-client-id";
    this.unusedClientSecret = "js-unused-client-secret";
    this.unusedExpiry = 3600;
  }
}

// --- Unused object type (plain object acting as enum) ---
// CACOMI-EXPECT: UnusedCode
const unused_log_level = Object.freeze({
  VERBOSE: "verbose",
  DEBUG: "debug",
  WARN: "warn",
  ERROR: "error",
});

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
function debugDumpCredentials(email, token) {
  console.log("debugDumpCredentials email:", email);
  console.log("debugDumpCredentials token:", token);
  console.debug("debugDumpCredentials PASSWORD:", PASSWORD);
  console.error("debugDumpCredentials API_KEY:", API_KEY);
}

// CACOMI-EXPECT: PrintAndLogs
function logJWTOnStartup() {
  console.error("Startup JWT:", JWT);
  console.debug("Startup ACCESS_TOKEN:", ACCESS_TOKEN);
}

// --- Negative example: logs a non-sensitive item count ---
// CACOMI-EXPECT: none
function logItemCount(count) {
  console.log("Items processed:", count);
}
