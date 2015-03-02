//
//  HereClientParsing.m
//  Here Search
//
//  Created by Hoefele, Claus on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "HereClientParsing.h"

#import "HereLocationItem.h"

static NSString *BASE_URL = @"https://places.cit.api.here.com";

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
    
    NSString *urlAsString = [NSString stringWithFormat:@"%@/places/v1/discover/search?at=%f,%f&q=%@&td=plain", BASE_URL, coordinate.latitude, coordinate.longitude, escapedQuery];
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

@end
