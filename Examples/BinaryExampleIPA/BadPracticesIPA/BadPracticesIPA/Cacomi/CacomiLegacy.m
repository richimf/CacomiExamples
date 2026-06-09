//
//  CacomiLegacy.m
//  BadPracticesIPA
//
//  Objective-C fixture: hardcoded secret + NSLog leak.
//

#import "CacomiLegacy.h"

@implementation CacomiLegacy

// BAD: hardcoded API key in Objective-C                    // CACOMI-EXPECT: SecretPattern
static NSString *const kCacomiObjcApiKey = @"sk_live_DUMMY_objc_cacomiApiKey1234567890";

+ (void)leakSensitiveLog {
    NSString *token = @"eyJhbGciOiJIUzI1NiJ9.payload.sig"; // dummy
    // BAD: NSLog leaks token + api_key                      // CACOMI-EXPECT: PrintAndLogs
    NSLog(@"[CacomiLegacy] token=%@ api_key=%@", token, kCacomiObjcApiKey);
}

@end
