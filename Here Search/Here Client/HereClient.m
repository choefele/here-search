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
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appCode;

@end

@implementation HereClient

- (instancetype)initWithAppID:(NSString *)appID appCode:(NSString *)appCode
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        _appID = appID;
        _appCode = appCode;
    }
    
    return self;
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

- (NSMutableURLRequest *)authenticatedRequestForRequest:(NSMutableURLRequest *)request useHTTPHeaders:(BOOL)useHTTPHeaders
{
    if (useHTTPHeaders) {
        NSString *clientCredentials = [NSString stringWithFormat:@"%@:%@", self.appID, self.appCode];
        NSString *encodedClientCredentials = [[clientCredentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        NSString *basicHeader = [NSString stringWithFormat:@"Basic %@", encodedClientCredentials];
        [request setValue:basicHeader forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *authentication = [NSString stringWithFormat:@"&app_id=%@&app_code=%@", self.appID, self.appCode];
        NSString *url = [request.URL.absoluteString stringByAppendingString:authentication];
        request.URL = [NSURL URLWithString:url];
    }
    
    return request;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = self.allowsAnyHTTPSCertificate ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengePerformDefaultHandling;
    completionHandler(disposition, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (NSURLSessionDataTask *)retrieveSearchResultsWithCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query completionHandler:(void (^)(NSArray *locationItems, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [HereClientParsing searchRequestForCoordinate:coordinate query:query];
    request = [self authenticatedRequestForRequest:request useHTTPHeaders:YES];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *locationItems = error ? nil : [HereClientParsing locationItemsForData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(locationItems, error);
        });
    }];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)retrieveRouteWithLocationItems:(NSArray *)locationItems completionHandler:(void (^)(MKPolyline *polyline, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [HereClientParsing routeRequestForLocationItems:locationItems];
    request = [self authenticatedRequestForRequest:request useHTTPHeaders:NO];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        MKPolyline *polyline = error ? nil : [HereClientParsing shapeForData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(polyline, error);
        });
    }];
    [task resume];
    
    return task;
}

@end
