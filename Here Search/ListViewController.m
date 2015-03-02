//
//  ListViewController.m
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "ListViewController.h"

#import "ItineraryModel.h"
#import "HereLocationItem.h"

@interface ListViewController ()

@property (nonatomic) UISearchController *searchController;

@end

@implementation ListViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.editing = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itineraryModel.locationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HereLocationItem *locationItem = self.itineraryModel.locationItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = locationItem.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.itineraryModel deleteLocationItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.itineraryModel moveLocationItemFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

@end
