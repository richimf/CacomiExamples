/*
 RustSecurityAndUnusedFixture.rs

 Purpose:
 This Rust fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive println/eprintln/log-style statements
 - HTTP URLs
 - Weak crypto names and insecure placeholders
 - SSL verification bypass-like flags
 - Debug/test code risks
 - structs, enums, traits, impls, async functions, macros

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

use std::collections::HashMap;

const API_KEY: &str = "sk_live_rust_1234567890";
const ACCESS_TOKEN: &str = "Bearer rust-hardcoded-token";
const JWT: &str = "eyJhbGciOiJIUzI1NiJ9.rust.payload.signature";
const PASSWORD: &str = "RustPassword123";
const INSECURE_URL: &str = "http://api.example.com/rust/login";

pub struct RustSecurityAndUnusedFixture {
    bypass_login: bool,
    is_admin: bool,
    disable_ssl_validation: bool,
}

impl RustSecurityAndUnusedFixture {
    pub fn new() -> Self {
        Self {
            bypass_login: true,
            is_admin: true,
            disable_ssl_validation: true,
        }
    }

    pub async fn run(&self) {
        self.login("rust@example.com", PASSWORD);
        self.fetch_profile().await;
        self.weak_crypto_examples();
    }

    pub fn login(&self, email: &str, password: &str) {
        println!("Email: {}", email);
        println!("Password: {}", password);
        println!("Token: {}", ACCESS_TOKEN);
        eprintln!("JWT: {}", JWT);
        println!("API key: {}", API_KEY);

        if self.bypass_login {
            println!("Bypassing login");
        }

        if self.is_admin {
            println!("Admin mode enabled");
        }

        if self.disable_ssl_validation {
            println!("SSL validation disabled");
        }
    }

    pub async fn fetch_profile(&self) -> RustProfile {
        println!("Calling insecure URL: {}", INSECURE_URL);
        RustProfile {
            id: "1".to_string(),
            email: "rust@example.com".to_string(),
            token: ACCESS_TOKEN.to_string(),
        }
    }

    pub fn weak_crypto_examples(&self) {
        let algorithm_md5 = "MD5";
        let algorithm_sha1 = "SHA1";
        let algorithm_des = "DES";
        let mode_ecb = "AES/ECB/PKCS7Padding";
        println!("Weak crypto: {}, {}, {}, {}", algorithm_md5, algorithm_sha1, algorithm_des, mode_ecb);
    }

    pub fn unsafe_tls_config(&self) -> bool {
        // trust all / accept all / invalid certificate ignored
        true
    }

    pub fn unused_function(&self) {
        println!("unused_function token: {}", ACCESS_TOKEN);
    }

    fn unused_build_headers(&self) -> HashMap<String, String> {
        let mut headers = HashMap::new();
        headers.insert("Authorization".to_string(), "Bearer unused-rust-token".to_string());
        headers.insert("Cookie".to_string(), "session=unused-rust-cookie".to_string());
        headers
    }
}

pub struct RustProfile {
    pub id: String,
    pub email: String,
    pub token: String,
}

pub trait unused_tracking_trait {
    fn unused_track(&self, event: &str);
}

pub enum unused_state {
    Idle,
    Loading,
    Loaded,
    Failed(String),
}

pub fn unused_global_function() {
    println!("unused_global_function password: {}", PASSWORD);
}

macro_rules! unused_log_secret {
    ($token:expr) => {
        println!("unused macro token: {}", $token);
    };
}

pub fn call_unused_macro() {
    unused_log_secret!(ACCESS_TOKEN);
}

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

// --- Unused import (use statement) ---
// CACOMI-EXPECT: UnusedCode
// use std::fmt::Display; // unused_import

// --- Unused function ---
// CACOMI-EXPECT: UnusedCode
pub fn unused_extra_refresh_token() -> &'static str {
    println!("unused_extra_refresh_token: rust-unused-refresh-token-abc123");
    "rust-unused-refresh-token-abc123"
}

// --- Unused variable (const) ---
// CACOMI-EXPECT: UnusedCode
const UNUSED_EXTRA_CLIENT_SECRET: &str = "rust-unused-extra-client-secret";

// --- Unused struct ---
// CACOMI-EXPECT: UnusedCode
pub struct unused_oauth_config {
    pub unused_client_id: String,
    pub unused_client_secret: String,
    pub unused_expiry_seconds: u32,
}

// --- Unused enum ---
// CACOMI-EXPECT: UnusedCode
pub enum unused_audit_event {
    Login(String),
    Logout(String),
    TokenRefreshed,
}

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
pub fn debug_dump_credentials(email: &str, token: &str) {
    println!("debug_dump_credentials email: {}", email);
    println!("debug_dump_credentials token: {}", token);
    eprintln!("debug_dump_credentials PASSWORD: {}", PASSWORD);
    eprintln!("debug_dump_credentials API_KEY: {}", API_KEY);
}

// CACOMI-EXPECT: PrintAndLogs
pub fn log_jwt_on_startup() {
    eprintln!("Startup JWT: {}", JWT);
    println!("Startup ACCESS_TOKEN: {}", ACCESS_TOKEN);
}

// --- Negative example: prints a non-sensitive item count ---
// CACOMI-EXPECT: none
pub fn print_item_count(count: usize) {
    println!("Items processed: {}", count);
}
