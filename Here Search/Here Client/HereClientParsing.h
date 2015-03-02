//
//  HereClientParsing.h
//  Here Search
//
//  Created by Hoefele, Claus on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HereClientParsing : NSObject

+ (NSMutableURLRequest *)searchRequestForCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query;
+ (NSArray *)locationItemsForData:(NSData *)data;
+ (NSMutableURLRequest *)routeRequestForLocationItems:(NSArray *)locationItems;
+ (MKPolyline *)shapeForData:(NSData *)data;
+ (NSArray *)waypointsForData:(NSData *)data;

@end
