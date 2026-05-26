/*
 ObjectiveCSecurityAndUnusedFixture.h

 Purpose:
 Header fixture for Objective-C security and unused code testing.
 It declares used APIs and intentionally unused declarations named unused_*.

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjectiveCSecurityAndUnusedFixture : NSObject <NSURLSessionDelegate>

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) BOOL bypassLogin;

- (void)run;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password;
- (void)callInsecureEndpoint;
- (void)weakCryptoExamples;
- (void)installUnsafeSession;

- (void)unused_function;
- (NSString *)unused_buildAuthorizationHeader;

@end

@interface unused_objective_c_helper : NSObject

@property (nonatomic, copy) NSString *unused_secret;

- (void)unused_method;

@end

NS_ASSUME_NONNULL_END
