//
//  HereLocationItem.m
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "HereLocationItem.h"

@interface HereLocationItem()

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation HereLocationItem

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _title = title;
        _coordinate = coordinate;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _title = [coder decodeObjectOfClass:NSString.class forKey:@"title"];
        double latitude = [coder decodeDoubleForKey:@"coordinate.latitude"];
        double longitude = [coder decodeDoubleForKey:@"coordinate.longitude"];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeDouble:self.coordinate.latitude forKey:@"coordinate.latitude"];
    [coder encodeDouble:self.coordinate.longitude forKey:@"coordinate.longitude"];
}

@end
