//
//  LegacyCrypto.m
//  CacomiTestApp
//
//  Objective-C fixtures: insecure logging, CC_MD5, hardcoded secret.
//

#import "LegacyCrypto.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LegacyCrypto

// CACOMI-EXPECT[SecretPatternRule|high]: hardcoded API key in Objective-C
static NSString *const kHardcodedAPIKey = @"sk_live_FAKEcacomiObjcSecret1234567890abcdef";

+ (NSString *)md5OfString:(NSString *)input {
    const char *cstr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // CACOMI-EXPECT[WeakCryptoExtensions|high]: CC_MD5 in Objective-C is a broken hash
    CC_MD5(cstr, (CC_LONG)strlen(cstr), digest);
    NSMutableString *hex = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hex appendFormat:@"%02x", digest[i]];
    }
    return hex;
}

+ (void)logSensitive {
    NSString *token = @"eyJhbGciOiJIUzI1NiJ9.payload.signature";
    // CACOMI-EXPECT[LogParser|critical]: NSLog leaks sensitive token
    NSLog(@"auth token=%@ api_key=%@", token, kHardcodedAPIKey);
}

@end
