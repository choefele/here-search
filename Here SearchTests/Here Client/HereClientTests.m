//
//  HereClientTests.m
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HereClient.h"
#import "HereLocationItem.h"

static const NSTimeInterval TIMEOUT = 5.0;
static NSString *APP_ID = @"DemoAppId01082013GAL";
static NSString *APP_CODE = @"AJKnXv84fjrb0KIHawS0Tg";

@interface HereClientTests : XCTestCase

@property (nonatomic) HereClient *client;

@end

@implementation HereClientTests

- (void)setUp
{
    [super setUp];
    
    self.client = [[HereClient alloc] initWithAppID:APP_ID appCode:APP_CODE];
    self.client.allowsAnyHTTPSCertificate = YES;
}

- (void)testSearch
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.5233, 13.4127);   // Alexanderplatz
    NSString *query = @"brandenburger tor";

    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [self.client retrieveSearchResultsWithCoordinate:coordinate query:query completionHandler:^(NSArray *locationItems, NSError *error) {
        XCTAssertTrue(locationItems.count > 0);
        XCTAssertNotNil([locationItems.firstObject title]);
        XCTAssertNotEqualWithAccuracy([locationItems.firstObject coordinate].latitude, 0.0, DBL_EPSILON);
        XCTAssertNotEqualWithAccuracy([locationItems.firstObject coordinate].longitude, 0.0, DBL_EPSILON);

        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:TIMEOUT handler:nil];
}

@end
