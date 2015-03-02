//
//  ItineraryModelTests.m
//  Here Search
//
//  Created by Hoefele, Claus on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ItineraryModel.h"
#import "HereLocationItem.h"

@interface ItineraryModelTests : XCTestCase

@property (nonatomic) ItineraryModel *itineraryModel;

@end

@implementation ItineraryModelTests

- (void)setUp
{
    [super setUp];
    
    self.itineraryModel = [[ItineraryModel alloc] initWithAppGroupName:@"test"];
    [self.itineraryModel reset];
}

- (void)testAppendLocationItem
{
    XCTAssertEqual(self.itineraryModel.locationItems.count, 0);
    HereLocationItem *locationItem = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    [self.itineraryModel appendLocationItem:locationItem];
    XCTAssertEqual(self.itineraryModel.locationItems.count, 1);
    XCTAssertEqualObjects(self.itineraryModel.locationItems.firstObject, locationItem);
}

- (void)testDeleteLocationItem
{
    HereLocationItem *locationItem = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    [self.itineraryModel appendLocationItem:locationItem];

    [self.itineraryModel deleteLocationItemAtIndex:0];
    XCTAssertEqual(self.itineraryModel.locationItems.count, 0);
}

- (void)testMoveLocationItem
{
    HereLocationItem *locationItem0 = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    HereLocationItem *locationItem1 = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    [self.itineraryModel appendLocationItem:locationItem0];
    [self.itineraryModel appendLocationItem:locationItem1];

    XCTAssertEqualObjects(self.itineraryModel.locationItems[0], locationItem0);
    XCTAssertEqualObjects(self.itineraryModel.locationItems[1], locationItem1);
    [self.itineraryModel moveLocationItemFromIndex:0 toIndex:1];
    XCTAssertEqualObjects(self.itineraryModel.locationItems[0], locationItem1);
    XCTAssertEqualObjects(self.itineraryModel.locationItems[1], locationItem0);
}

- (void)testPolyline
{
    HereLocationItem *locationItem0 = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(1.123456789, 2.123456789)];
    HereLocationItem *locationItem1 = [[HereLocationItem alloc] initWithTitle:nil coordinate:CLLocationCoordinate2DMake(3.123456789, 4.123456789)];
    [self.itineraryModel appendLocationItem:locationItem0];
    [self.itineraryModel appendLocationItem:locationItem1];

    // Use low accuracy because coordinates have been converted to map points internally
    MKPolyline *polyline = self.itineraryModel.polyline;
    XCTAssertEqual(polyline.pointCount, 2);
    CLLocationCoordinate2D coordinates[polyline.pointCount];
    [polyline getCoordinates:coordinates range:NSMakeRange(0, polyline.pointCount)];
    XCTAssertEqualWithAccuracy(coordinates[0].latitude, locationItem0.coordinate.latitude, 0.1);
    XCTAssertEqualWithAccuracy(coordinates[0].longitude, locationItem0.coordinate.longitude, 0.1);
    XCTAssertEqualWithAccuracy(coordinates[1].latitude, locationItem1.coordinate.latitude, 0.1);
    XCTAssertEqualWithAccuracy(coordinates[1].longitude, locationItem1.coordinate.longitude, 0.1);
}

@end
