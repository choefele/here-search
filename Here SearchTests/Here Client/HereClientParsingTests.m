//
//  HereClientParsingTests.m
//  Here Search
//
//  Created by Hoefele, Claus on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HereLocationItem.h"
#import "HereClientParsing.h"

@interface HereClientParsingTests : XCTestCase

@end

@implementation HereClientParsingTests

+ (NSData *)loadDataWithFileName:(NSString *)fileName ofType:(NSString *)type
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filePath = [bundle pathForResource:fileName ofType:type];
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)testParseLocationItems
{
    NSData *data = [self.class loadDataWithFileName:@"search" ofType:@"json"];
    NSArray *locationItems = [HereClientParsing locationItemsForData:data];
    XCTAssertEqual(locationItems.count, 3);
    HereLocationItem *locationItem = locationItems.firstObject;
    XCTAssertEqualObjects(locationItem.title, @"Brandenburg Gate (Brandenburger Tor)");
    XCTAssertEqualWithAccuracy(locationItem.coordinate.latitude, 52.51628, DBL_EPSILON);
    XCTAssertEqualWithAccuracy(locationItem.coordinate.longitude, 13.37768, DBL_EPSILON);
}

- (void)testQuery
{
    NSString *query = @"Brandenburger Tor";
    NSMutableURLRequest *request = [HereClientParsing searchRequestForCoordinate:CLLocationCoordinate2DMake(0, 0) query:query];
    XCTAssertTrue([request.URL.query containsString:@"q=Brandenburger%20Tor"]);
}

- (void)testCoordinate
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.51628, 13.37768);
    NSMutableURLRequest *request = [HereClientParsing searchRequestForCoordinate:coordinate query:nil];
    XCTAssertTrue([request.URL.query containsString:@"at=52.516280,13.377680"]);
}

@end
