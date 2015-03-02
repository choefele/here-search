//
//  HereClient.h
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HereClient : NSObject

@property (nonatomic) BOOL allowsAnyHTTPSCertificate;

- (instancetype)initWithAppID:(NSString *)appID appCode:(NSString *)appCode NS_DESIGNATED_INITIALIZER;

- (NSURLSessionDataTask *)retrieveSearchResultsWithCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query completionHandler:(void (^)(NSArray *locationItems, NSError *error))completionHandler;
- (NSURLSessionDataTask *)retrieveRouteWithLocationItems:(NSArray *)locationItems completionHandler:(void (^)(MKPolyline *polyline, NSError *error))completionHandler;

@end
