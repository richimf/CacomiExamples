//
//  UnsafeFormat.m
//  BadPracticesIPA
//
//  Cacomi fixture: format-string vulnerabilities and unsafe C-string logging in Objective-C (M7 / M8).
//  All secret values are FAKE/dummy — for static-analysis testing only.
//

#import <Foundation/Foundation.h>
#import <stdio.h>

// CACOMI-EXPECT[SecretPatternRule|high]: hardcoded API secret in Objective-C compilation unit
static NSString *const kFakeAPISecret = @"sk_live_FAKEcacomiUnsafeFormat_9876543210abcdef";

// CACOMI-EXPECT[SecretPatternRule|high]: hardcoded admin password constant
static const char *kFakeAdminPassword = "FAKE_CACOMI_ADMIN_PASS_!@#$%1234";

/// Logs user-provided input via NSLog with a format-string-from-variable pattern.
/// An attacker who controls |userInput| can inject %@ / %n / %s specifiers.
void cacomi_log_with_variable_format(NSString *userInput) {
    // CACOMI-EXPECT[LogParser|critical]: NSLog called with user-controlled format string — format-string injection risk
    NSLog(userInput);  // BAD: first arg is a user-controlled format string

    // CACOMI-EXPECT[LogParser|high]: NSLog leaks API secret alongside user input
    NSLog(@"request from user=%@ api_key=%@", userInput, kFakeAPISecret);
}

/// Converts a C string from userInput and logs via printf — %s with uncontrolled width.
void cacomi_printf_user_cstring(const char *userInput) {
    // CACOMI-EXPECT[LogParser|critical]: printf with %s on attacker-controlled C string — no width bound, potential stack read via format specifiers
    printf(userInput);  // BAD: format-string-from-variable

    // CACOMI-EXPECT[LogParser|high]: printf leaks hardcoded admin password next to user input
    printf("user=%s pass=%s\n", userInput, kFakeAdminPassword);
}

/// Builds an NSString format dynamically from a remote-supplied template, then passes it to NSLog.
void cacomi_dynamic_format_string(NSString *remoteTemplate, NSString *value) {
    // CACOMI-EXPECT[LogParser|critical]: format string constructed from remote-controlled template — full format-string injection
    NSString *fmt = [remoteTemplate stringByAppendingString:@" value=%@"];
    NSLog(fmt, value);  // BAD: attacker-controlled format string
}

/// Uses %s to splice a C-string representation of sensitive data into a log line.
void cacomi_log_sensitive_cstring(const char *sensitiveData) {
    // CACOMI-EXPECT[LogParser|high]: %s used to log sensitive C-string — no length validation, leaks data to device log
    NSLog(@"[DEBUG] raw data: %s", sensitiveData);

    // CACOMI-EXPECT[LogParser|high]: fprintf to stderr also observable via Console.app on a connected device
    fprintf(stderr, "sensitive=%s secret=%s\n", sensitiveData, kFakeAdminPassword);
}

/// Negative: NSLog with a hardcoded, non-sensitive format string and no user-controlled parts.
void cacomi_safe_log(NSString *displayName) {
    // CACOMI-NEGATIVE[LogParser]: literal format string with no user-controlled format specifiers — no injection risk and no sensitive data
    NSLog(@"User display name: %@", displayName);
}

/// Negative: NSString stringWithFormat uses a literal format — safe even with variable values.
void cacomi_safe_string_format(int count) {
    // CACOMI-NEGATIVE[LogParser]: literal format string; count is a non-sensitive integer
    NSString *msg = [NSString stringWithFormat:@"Items loaded: %d", count];
    (void)msg;
}
