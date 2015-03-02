//
//  HereClient.m
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "HereClient.h"

#import "HereClientParsing.h"

@interface HereClient() <NSURLSessionDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSString *encodedClientCredentials;

@end

@implementation HereClient

- (instancetype)initWithAppID:(NSString *)appID appCode:(NSString *)appCode
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        NSString *clientCredentials = [NSString stringWithFormat:@"%@:%@", appID, appCode];
        _encodedClientCredentials = [[clientCredentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
    
    return self;
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = self.allowsAnyHTTPSCertificate ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengePerformDefaultHandling;
    completionHandler(disposition, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (NSURLSessionDataTask *)retrieveSearchResultsWithCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query completionHandler:(void (^)(NSArray *locationItems, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [HereClientParsing searchRequestForCoordinate:coordinate query:query];
    request = [self authenticatedRequestForRequest:request];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *locationItems = error ? nil : [HereClientParsing locationItemsForData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(locationItems, error);
        });
    }];
    [task resume];
    
    return task;
}

- (NSMutableURLRequest *)authenticatedRequestForRequest:(NSMutableURLRequest *)request
{
    NSString *basicHeader = [NSString stringWithFormat:@"Basic %@", self.encodedClientCredentials];
    [request setValue:basicHeader forHTTPHeaderField:@"Authorization"];

    return request;
}

@end
