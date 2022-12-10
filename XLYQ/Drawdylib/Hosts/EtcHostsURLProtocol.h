
#import <Foundation/Foundation.h>

@protocol EtcHostsConfiguration;

/**
 
 */
@interface EtcHostsURLProtocol : NSURLProtocol
  
+ (void)configureHostsWithBlock:(void (^)(id <EtcHostsConfiguration> configuration))block;

@end

#pragma mark -

/**
 
 */
@protocol EtcHostsConfiguration

/**
 
 */
- (void)resolveHostName:(NSString *)hostName
            toIPAddress:(NSString *)IPAddress;

@end
