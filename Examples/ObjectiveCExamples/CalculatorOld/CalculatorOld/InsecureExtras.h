//
//  InsecureExtras.h
//  CalculatorOld
//
//  Cacomi fixture: deliberately insecure helpers for the legacy Obj-C demo.
//  ALL VALUES ARE FAKE / NON-FUNCTIONAL — intentional bad practice for testing only.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InsecureExtras : NSObject

- (NSString *)md5OfString:(NSString *)input;
- (void)persistToken:(NSString *)token;
- (void)fetchInsecurely;
- (void)logCredentials:(NSString *)password token:(NSString *)token;
- (void)copyName:(const char *)name;

@end

NS_ASSUME_NONNULL_END
