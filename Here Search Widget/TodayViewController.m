//
//  TodayViewController.m
//  Here Search Widget
//
//  Created by Hoefele, Claus on 02.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "ItineraryModel.h"
#import "HereLocationItem.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic) ItineraryModel *itineraryModel;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itineraryModel = [[ItineraryModel alloc] initWithAppGroupName:@"group.com.claushoefele.HereSearch"];

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.preferredContentSize = self.tableView.contentSize;
}

#pragma mark - NCWidgetProviding

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    defaultMarginInsets.left = 0;
    return defaultMarginInsets;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
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

@end
