


#import "NSObject+URL.h"
#import "EtcHostsURLProtocol.h"

@implementation NSObject (URL)

+ (void)load
{
    [NSURLProtocol registerClass:[EtcHostsURLProtocol class]];
    [EtcHostsURLProtocol configureHostsWithBlock:^(id <EtcHostsConfiguration> configuration) {
        [configuration resolveHostName:@"down.anticheatexpert.com" toIPAddress:@"127.0.0.1"];
        [configuration resolveHostName:@"down.pandora.qq.com" toIPAddress:@"127.0.0.1"];
        [configuration resolveHostName:@"ios.crashsight.qq.com" toIPAddress:@"127.0.0.1"];
        [configuration resolveHostName:@"ios.bugly.qq.com" toIPAddress:@"127.0.0.1"];
        [configuration resolveHostName:@"nj.cschannel.anticheatexpert.com" toIPAddress:@"127.0.0.1"];
    }];
}
   

@end
