/*
 GoSecurityAndUnusedFixture.go

 Purpose:
 This Go fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive fmt/log statements
 - HTTP URLs
 - Weak crypto imports and usage
 - TLS verification bypass
 - Debug/test flags
 - structs, interfaces, methods, goroutines, maps

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

package main

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/tls"
	"fmt"
	"log"
	"net/http"
)

const apiKey = "sk_live_go_1234567890"
const accessToken = "Bearer go-hardcoded-token"
const jwt = "eyJhbGciOiJIUzI1NiJ9.go.payload.signature"
const password = "GoPassword123"
const insecureURL = "http://api.example.com/go/login"

var bypassLogin = true
var isAdmin = true
var disableSSLValidation = true

type GoSecurityAndUnusedFixture struct {
	token string
}

func NewGoSecurityAndUnusedFixture() *GoSecurityAndUnusedFixture {
	return &GoSecurityAndUnusedFixture{token: accessToken}
}

func (g *GoSecurityAndUnusedFixture) Run() {
	g.Login("go@example.com", password)
	g.CallInsecureAPI()
	g.WeakCryptoExamples()
	g.UnsafeHTTPClient()
}

func (g *GoSecurityAndUnusedFixture) Login(email string, password string) {
	fmt.Println("Email:", email)
	fmt.Println("Password:", password)
	fmt.Println("Token:", g.token)
	log.Println("JWT:", jwt)
	log.Println("API key:", apiKey)

	if bypassLogin {
		log.Println("Bypassing login")
	}

	if isAdmin {
		log.Println("Admin mode enabled")
	}

	if disableSSLValidation {
		log.Println("SSL validation disabled")
	}
}

func (g *GoSecurityAndUnusedFixture) CallInsecureAPI() {
	req, _ := http.NewRequest("GET", insecureURL, nil)
	req.Header.Set("Authorization", g.token)
	req.Header.Set("X-API-Key", apiKey)
	log.Println("Calling insecure URL:", insecureURL)
	log.Println("Headers token:", g.token)
}

func (g *GoSecurityAndUnusedFixture) WeakCryptoExamples() {
	md5.Sum([]byte("secret"))
	sha1.Sum([]byte("secret"))
	algorithm := "DES ECB RC4"
	log.Println("Weak crypto:", algorithm)
}

func (g *GoSecurityAndUnusedFixture) UnsafeHTTPClient() *http.Client {
	return &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				InsecureSkipVerify: true,
			},
		},
	}
}

func (g *GoSecurityAndUnusedFixture) unused_function() {
	log.Println("unused_function token:", g.token)
}

func unused_buildHeaders() map[string]string {
	return map[string]string{
		"Authorization": "Bearer unused-go-token",
		"Cookie":        "session=unused-go-cookie",
	}
}

type unused_tracker interface {
	unused_track(event string)
}

type unused_helper_struct struct {
	unused_secret string
}

func (u unused_helper_struct) unused_method() {
	fmt.Println("unused_secret:", u.unused_secret)
}

func main() {
	fixture := NewGoSecurityAndUnusedFixture()
	fixture.Run()
}

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

// --- Unused import (noted inline; Go unused imports are compile errors so marked as comment) ---
// CACOMI-EXPECT: UnusedCode
// import "os"  /* unused_import — present only to exercise unused-import detection */

// --- Unused function ---
// CACOMI-EXPECT: UnusedCode
func unused_extra_refresh_token() string {
	log.Println("unused_extra_refresh_token: go-unused-refresh-token-abc123")
	return "go-unused-refresh-token-abc123"
}

// --- Unused variable (package-level) ---
// CACOMI-EXPECT: UnusedCode
var unused_extra_client_secret = "go-unused-extra-client-secret"

// --- Unused type (struct) ---
// CACOMI-EXPECT: UnusedCode
type unused_oauth_config struct {
	unusedClientID     string
	unusedClientSecret string
	unusedExpirySeconds int
}

// --- Unused interface ---
// CACOMI-EXPECT: UnusedCode
type unused_audit_logger interface {
	unused_logEvent(event string, metadata map[string]string)
}

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
func debugDumpCredentials(email, token string) {
	fmt.Println("debugDumpCredentials email:", email)
	fmt.Println("debugDumpCredentials token:", token)
	log.Println("debugDumpCredentials password:", password)
	log.Println("debugDumpCredentials apiKey:", apiKey)
}

// CACOMI-EXPECT: PrintAndLogs
func logJWTOnStartup() {
	log.Println("Startup JWT:", jwt)
	fmt.Println("Startup accessToken:", accessToken)
}

// --- Negative example: prints a non-sensitive counter value ---
// CACOMI-EXPECT: none
func printItemCount(count int) {
	fmt.Println("Items processed:", count)
}
