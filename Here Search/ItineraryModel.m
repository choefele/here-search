//
//  ItineraryDataSource.m
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "ItineraryModel.h"

#import "HereLocationItem.h"

static NSString *PERSISTED_KEY = @"itineraryModel";

@interface ItineraryModel()

@property (nonatomic) NSMutableArray *mutableLocationItems;
@property (nonatomic) NSUserDefaults *userDefaults;

@end

@implementation ItineraryModel

- (instancetype)initWithAppGroupName:(NSString *)appGroupName
{
    self = [super init];
    if (self) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:appGroupName];
        _mutableLocationItems = [self readData];
        
        // Test data
        if (_mutableLocationItems.count == 0) {
            HereLocationItem *locationItem0 = [[HereLocationItem alloc] initWithTitle:@"Nokia Here" coordinate:CLLocationCoordinate2DMake(52.531038, 13.384600)];
            HereLocationItem *locationItem1 = [[HereLocationItem alloc] initWithTitle:@"Brandenburger Tor" coordinate:CLLocationCoordinate2DMake(52.516455, 13.377677)];
            [self appendLocationItem:locationItem0];
            [self appendLocationItem:locationItem1];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [self.userDefaults synchronize];
}

- (NSArray *)locationItems
{
    return [self.mutableLocationItems copy];
}

- (void)writeData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableLocationItems];
    [self.userDefaults setObject:data forKey:PERSISTED_KEY];
}

- (NSMutableArray *)readData
{
    NSMutableArray *array;
    NSData *data = [self.userDefaults objectForKey:PERSISTED_KEY];
    if (data) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        array = [NSMutableArray array];
    }

    return array;
}

- (void)reset
{
    self.mutableLocationItems = [NSMutableArray array];
    [self.userDefaults removeObjectForKey:PERSISTED_KEY];
}

- (void)appendLocationItem:(HereLocationItem *)locationItem
{
    [self.mutableLocationItems addObject:locationItem];
    [self writeData];
}

- (void)deleteLocationItemAtIndex:(NSUInteger)index
{
    [self.mutableLocationItems removeObjectAtIndex:index];
    [self writeData];
}

- (void)moveLocationItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    id locationItem = self.locationItems[fromIndex];
    [self.mutableLocationItems removeObject:locationItem];
    [self.mutableLocationItems insertObject:locationItem atIndex:toIndex];
    [self writeData];
}

- (MKPolyline *)polyline
{
    CLLocationCoordinate2D coordinates[self.mutableLocationItems.count];
    CLLocationCoordinate2D *currentCoordinate = coordinates;
    for (id<MKAnnotation> annotation in self.mutableLocationItems) {
        *currentCoordinate++ = annotation.coordinate;
    }
    return [MKPolyline polylineWithCoordinates:coordinates count:self.mutableLocationItems.count];
}

@end
