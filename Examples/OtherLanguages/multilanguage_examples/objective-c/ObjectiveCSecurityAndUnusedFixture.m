/*
 ObjectiveCSecurityAndUnusedFixture.m

 Purpose:
 This Objective-C fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive NSLog / printf logs
 - HTTP URLs
 - Weak crypto through CommonCrypto
 - SSL trust bypass patterns
 - Debug/test code risks

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

#import "ObjectiveCSecurityAndUnusedFixture.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@implementation ObjectiveCSecurityAndUnusedFixture

- (instancetype)init {
    self = [super init];
    if (self) {
        _apiKey = @"sk_live_objc_1234567890";
        _accessToken = @"Bearer objc-hardcoded-access-token";
        _bypassLogin = YES;
    }
    return self;
}

- (void)run {
    [self loginWithEmail:@"objc@example.com" password:@"ObjCPassword123"];
    [self callInsecureEndpoint];
    [self weakCryptoExamples];
    [self installUnsafeSession];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
    NSString *jwt = @"eyJhbGciOiJIUzI1NiJ9.objc.payload.signature";
    NSString *authorization = @"Bearer objc-authorization-token";

    NSLog(@"Email: %@", email);
    NSLog(@"Password: %@", password);
    NSLog(@"Token: %@", self.accessToken);
    NSLog(@"Authorization: %@", authorization);
    printf("JWT: %s\n", [jwt UTF8String]);

    if (self.bypassLogin) {
        NSLog(@"Bypassing login for debug user");
    }

    BOOL isAdmin = YES;
    if (isAdmin) {
        NSLog(@"Admin mode enabled");
    }
}

- (void)callInsecureEndpoint {
    NSString *insecureURL = @"http://api.example.com/objc/login";
    NSString *localURL = @"http://0.0.0.0:8080/debug";

    NSURL *url = [NSURL URLWithString:insecureURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:self.accessToken forHTTPHeaderField:@"Authorization"];
    [request setValue:self.apiKey forHTTPHeaderField:@"X-API-Key"];

    NSLog(@"Calling insecure URL: %@", insecureURL);
    NSLog(@"Local debug URL: %@", localURL);
    NSLog(@"Headers token: %@", self.accessToken);
}

- (void)weakCryptoExamples {
    const char *input = "secret-value";
    unsigned char md5Digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), md5Digest);

    unsigned char sha1Digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(input, (CC_LONG)strlen(input), sha1Digest);

    NSLog(@"Weak crypto MD5 and SHA1 completed");
}

- (void)installUnsafeSession {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSLog(@"Unsafe session: %@", session);
}

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;

    if (serverTrust != nil) {
        // trust all / accept all / ignore invalid certificate
        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        return;
    }

    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (BOOL)trustAllCertificates {
    return YES;
}

- (void)unused_function {
    NSLog(@"unused_function token: %@", self.accessToken);
}

- (NSString *)unused_buildAuthorizationHeader {
    return @"Bearer unused-objc-token";
}

- (void)unused_storePassword {
    NSString *password = @"unused-objc-password";
    NSLog(@"unused password: %@", password);
}

@end

@implementation unused_objective_c_helper

- (instancetype)init {
    self = [super init];
    if (self) {
        _unused_secret = @"unused-objective-c-secret";
    }
    return self;
}

- (void)unused_method {
    NSLog(@"unused_secret: %@", self.unused_secret);
}

@end

// ===== Cacomi: extra unused-code & logging fixtures =====
// All values below are FAKE / for testing only.

// --- Unused import (commented; would be a real #import to exercise unused-import detection) ---
// CACOMI-EXPECT: UnusedCode
// #import <MapKit/MapKit.h>  /* unused_import */

// --- Unused function (C-level) ---
// CACOMI-EXPECT: UnusedCode
static NSString *unused_extra_refresh_token(void) {
    return @"objc-unused-refresh-token-abc123";
}

// --- Unused variable (file-scope) ---
// CACOMI-EXPECT: UnusedCode
static NSString *const unused_extra_client_secret = @"objc-unused-extra-client-secret";

// --- Unused struct ---
// CACOMI-EXPECT: UnusedCode
typedef struct {
    const char *unused_client_id;
    const char *unused_client_secret;
    int         unused_expiry_seconds;
} unused_oauth_config_t;

// --- Unused Objective-C class ---
// CACOMI-EXPECT: UnusedCode
@interface unused_audit_logger : NSObject
@property (nonatomic, copy) NSString *unused_session_token;
- (void)unused_logEvent:(NSString *)event;
@end

@implementation unused_audit_logger
- (void)unused_logEvent:(NSString *)event {
    NSLog(@"unused_audit_logger event: %@  token: %@", event, self.unused_session_token);
}
@end

// --- Print/log positives ---
// CACOMI-EXPECT: PrintAndLogs
static void debugDumpCredentials(NSString *email, NSString *token) {
    NSLog(@"debugDumpCredentials email: %@", email);
    NSLog(@"debugDumpCredentials token: %@", token);
    printf("debugDumpCredentials password: %s\n", "objc-fake-password-123");
    NSLog(@"debugDumpCredentials apiKey: %@", @"sk_live_objc_extra_fake_key");
}

// CACOMI-EXPECT: PrintAndLogs
static void logJWTOnStartup(NSString *jwt, NSString *accessToken) {
    NSLog(@"Startup JWT: %@", jwt);
    printf("Startup ACCESS_TOKEN: %s\n", [accessToken UTF8String]);
}

// --- Negative example: logs a non-sensitive item count ---
// CACOMI-EXPECT: none
static void printItemCount(int count) {
    printf("Items processed: %d\n", count);
}
