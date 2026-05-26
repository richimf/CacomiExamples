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
