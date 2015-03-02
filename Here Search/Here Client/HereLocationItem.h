//
//  HereLocationItem.h
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HereLocationItem : NSObject<MKAnnotation, NSSecureCoding>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end
