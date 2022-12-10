   
#import "EtcHostsURLProtocol.h"

static NSString * const EtcHostModifiedPropertyKey = @"EtcHostModifiedProperty";

@interface EtcHostsConfiguration : NSObject <EtcHostsConfiguration>
- (NSString *)IPAddressForHostName:(NSString *)hostName;
@end

#pragma mark -

@interface EtcHostsURLProtocol () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (readwrite, nonatomic, strong) NSURLConnection *connection;
@end

@implementation EtcHostsURLProtocol

+ (EtcHostsConfiguration *)sharedConfiguration {
    static EtcHostsConfiguration * _sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[EtcHostsConfiguration alloc] init];
    });

    return _sharedConfiguration;
}

+ (void)configureHostsWithBlock:(void (^)(id <EtcHostsConfiguration> configuration))block {
    if (block) {
        block([self sharedConfiguration]);
    }
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [[self sharedConfiguration] IPAddressForHostName:[[request URL] host]] && ([[[request URL] scheme] caseInsensitiveCompare:@"http"] == NSOrderedSame || [[[request URL] scheme] caseInsensitiveCompare:@"https"] == NSOrderedSame);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:[[mutableRequest URL] absoluteString]];
    URLComponents.scheme = @"http";
    URLComponents.host = [[[self class] sharedConfiguration] IPAddressForHostName:URLComponents.host];

    mutableRequest.URL = [URLComponents URL];

    [NSURLProtocol setProperty:@(YES) forKey:EtcHostModifiedPropertyKey inRequest:mutableRequest];

    return mutableRequest;
}

- (void)startLoading {
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:[[self request] cachePolicy]];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end

#pragma mark -

@interface EtcHostsConfiguration ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableIPAddressesByHostName;
@end

@implementation EtcHostsConfiguration

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.mutableIPAddressesByHostName = [[NSMutableDictionary alloc] init];

    return self;
}

- (NSString *)IPAddressForHostName:(NSString *)hostName {
    return self.mutableIPAddressesByHostName[hostName];
}

#pragma mark - EtcHostsConfiguration

- (void)resolveHostName:(NSString *)hostName
            toIPAddress:(NSString *)IPAddress
{
    NSParameterAssert(hostName);
    NSParameterAssert(IPAddress);

    self.mutableIPAddressesByHostName[[hostName lowercaseString]] = IPAddress;
}

@end
