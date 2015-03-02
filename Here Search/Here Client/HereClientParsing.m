//
//  HereClientParsing.m
//  Here Search
//
//  Created by Hoefele, Claus on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "HereClientParsing.h"

#import "HereLocationItem.h"

static NSString *BASE_URL_SEARCH = @"https://places.cit.api.here.com";
static NSString *BASE_URL_ROUTE = @"https://route.cit.api.here.com";

@implementation HereClientParsing

#pragma mark - Search

+ (NSMutableURLRequest *)searchRequestForCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query
{
    query = query.length > 0 ? query : @"";
    NSMutableCharacterSet *queryValueAllowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [queryValueAllowedCharacterSet removeCharactersInRange:NSMakeRange('&', 1)]; // %26
    [queryValueAllowedCharacterSet removeCharactersInRange:NSMakeRange('=', 1)]; // %3D
    [queryValueAllowedCharacterSet removeCharactersInRange:NSMakeRange('?', 1)]; // %3F
    NSString *escapedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:queryValueAllowedCharacterSet];
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/places/v1/discover/search?at=%f,%f&q=%@&td=plain", BASE_URL_SEARCH, coordinate.latitude, coordinate.longitude, escapedQuery];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlAsString]];
    
    return request;
}

+ (NSArray *)locationItemsForData:(NSData *)data
{
    NSMutableArray *locationItems = [[NSMutableArray alloc] init];
    
    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *locationItemNodes = [dataAsJSON valueForKeyPath:@"results.items"];
    for (NSDictionary *locationItemNode in locationItemNodes) {
        NSString *title = [locationItemNode valueForKey:@"title"];
        NSArray *coordinateNodes = [locationItemNode valueForKeyPath:@"position"];
        double latitude = 0, longitude = 0;
        if (coordinateNodes.count == 2) {
            latitude = [coordinateNodes[0] doubleValue];
            longitude = [coordinateNodes[1] doubleValue];
        }
        
        HereLocationItem *locationItem = [[HereLocationItem alloc] initWithTitle:title coordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [locationItems addObject:locationItem];
    }
    
    return locationItems.count > 0 ? locationItems : nil;
}

+ (NSMutableURLRequest *)routeRequestForLocationItems:(NSArray *)locationItems
{
    NSMutableString *urlAsString = [NSMutableString stringWithFormat:@"%@/routing/7.2/calculateroute.json?mode=fastest;car&routeAttributes=sh,wp", BASE_URL_ROUTE];
    for (NSUInteger i = 0; i < locationItems.count; i++) {
        HereLocationItem *locationItem = locationItems[i];
        [urlAsString appendFormat:@"&waypoint%tu=geo!%f,%f", i, locationItem.coordinate.latitude, locationItem.coordinate.longitude];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlAsString]];
    
    return request;
}

+ (MKPolyline *)shapeForData:(NSData *)data
{
    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *routeNodes = [dataAsJSON valueForKeyPath:@"response.route"];
    NSArray *shapeNodes = [routeNodes.firstObject valueForKey:@"shape"];
    CLLocationCoordinate2D coordinates[shapeNodes.count];
    CLLocationCoordinate2D *currentCoordinate = coordinates;
    for (NSString *shapeNode in shapeNodes) {
        NSArray *latLong = [shapeNode componentsSeparatedByString:@","];
        double latitude = [latLong.firstObject doubleValue];
        double longitude = [latLong.lastObject doubleValue];
        *currentCoordinate++ = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    return [MKPolyline polylineWithCoordinates:coordinates count:shapeNodes.count];
}

+ (NSArray *)waypointsForData:(NSData *)data
{
    NSMutableArray *waypoints = [[NSMutableArray alloc] init];
    
    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *routeNodes = [dataAsJSON valueForKeyPath:@"response.route"];
    NSArray *waypointNodes = [routeNodes.firstObject valueForKey:@"waypoint"];
    for (NSDictionary *waypointNode in waypointNodes) {
        NSDictionary *coordinateNodes = [waypointNode valueForKeyPath:@"mappedPosition"];
        double latitude = [coordinateNodes[@"latitude"] doubleValue];
        double longitude = [coordinateNodes[@"longitude"] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [waypoints addObject:location];
    }

    return waypoints.count > 0 ? waypoints : nil;
}

@end
