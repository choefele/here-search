//
//  ItineraryDataSource.h
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class HereLocationItem;

@interface ItineraryModel : NSObject

@property (nonatomic, copy, readonly) NSArray *locationItems;
@property (nonatomic, copy, readonly) MKPolyline *polyline;

- (instancetype)initWithAppGroupName:(NSString *)appGroupName NS_DESIGNATED_INITIALIZER;

- (void)reset;
- (void)appendLocationItem:(HereLocationItem *)locationItem;
- (void)deleteLocationItemAtIndex:(NSUInteger)index;
- (void)moveLocationItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
