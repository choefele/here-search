//
//  AddLocationItemViewController.h
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HereLocationItem;

@interface AddLocationItemViewController : UITableViewController

@property (nonatomic, copy) void (^completionBlock)(HereLocationItem *locationItem);

@end
