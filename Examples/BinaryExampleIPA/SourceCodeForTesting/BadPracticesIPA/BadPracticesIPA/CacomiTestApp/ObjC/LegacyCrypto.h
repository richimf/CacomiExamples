//
//  LegacyCrypto.h
//  CacomiTestApp
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LegacyCrypto : NSObject
+ (NSString *)md5OfString:(NSString *)input;
+ (void)logSensitive;
@end

NS_ASSUME_NONNULL_END
