//
//  InsecureExtras.m
//  CalculatorOld
//
//  Cacomi fixture: deliberately insecure helpers for the legacy Obj-C demo.
//  ALL VALUES ARE FAKE / NON-FUNCTIONAL — intentional bad practice for testing only.
//

#import "InsecureExtras.h"
#import <CommonCrypto/CommonCrypto.h>
#import <string.h>
#import <stdio.h>
#import <stdlib.h>

// CACOMI-EXPECT[SecretPatternRule|high]: AWS access key id hardcoded
static NSString *const kAwsKey = @"AKIA3KZ8R2QW9TUV6BCD";
// CACOMI-EXPECT[SecretPatternRule|high]: hardcoded API password
static NSString *const kApiPassword = @"SuperSecret123!";
// CACOMI-EXPECT[SecretPatternRule|high]: bearer token baked into source
static NSString *const kBearer = @"Bearer abcdefghijklmnop1234567890";

@implementation InsecureExtras

// CACOMI-EXPECT[WeakCryptoExtensions|high]: MD5 used for hashing
- (NSString *)md5OfString:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);

    NSMutableString *out = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [out appendFormat:@"%02x", digest[i]];
    }
    return out;
}

// CACOMI-EXPECT[WeakCipherRule|high]: DES encryption (broken cipher)
- (NSData *)desEncrypt:(NSData *)data key:(NSData *)key {
    size_t outLength = data.length + kCCBlockSizeDES;
    NSMutableData *out = [NSMutableData dataWithLength:outLength];
    size_t moved = 0;
    CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionECBMode,
            key.bytes, key.length, NULL,
            data.bytes, data.length,
            out.mutableBytes, outLength, &moved);
    out.length = moved;
    return out;
}

// CACOMI-EXPECT[InsecureStorageRule|high]: token persisted to NSUserDefaults
- (void)persistToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"authToken"];
    [[NSUserDefaults standardUserDefaults] setObject:kApiPassword forKey:@"password"];
}

// CACOMI-EXPECT[insecureHTTP|high]: cleartext endpoint
- (void)fetchInsecurely {
    NSURL *url = [NSURL URLWithString:@"http://api.example.com/v1/login"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setValue:kBearer forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:req] resume];
}

// CACOMI-EXPECT[LogParser|critical]: password and token written to the log
- (void)logCredentials:(NSString *)password token:(NSString *)token {
    NSLog(@"login password = %@", password);
    NSLog(@"auth token = %@", token);
}

// CACOMI-EXPECT[UnsafeCAPIRule|critical]: unbounded strcpy/sprintf into fixed buffer
- (void)copyName:(const char *)name {
    char buffer[16];
    strcpy(buffer, name);            // CACOMI-EXPECT[UnsafeCAPIRule|critical]: strcpy
    char msg[32];
    sprintf(msg, "hi %s", buffer);   // CACOMI-EXPECT[UnsafeCAPIRule|high]: sprintf
    NSLog(@"%s", msg);
}

@end
