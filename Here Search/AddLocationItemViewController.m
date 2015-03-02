//
//  AddLocationItemViewController.m
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "AddLocationItemViewController.h"

#import "HereClient.h"
#import "HereLocationItem.h"

static NSString *APP_ID = @"DemoAppId01082013GAL";
static NSString *APP_CODE = @"AJKnXv84fjrb0KIHawS0Tg";

@interface AddLocationItemViewController ()<UISearchBarDelegate>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) HereClient *hereClient;
@property (nonatomic, copy) NSArray *locationItems;

@end

@implementation AddLocationItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hereClient = [[HereClient alloc] initWithAppID:APP_ID appCode:APP_CODE];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    // Test data
    HereLocationItem *locationItem0 = [[HereLocationItem alloc] initWithTitle:@"Rotes Rathaus" coordinate:CLLocationCoordinate2DMake(52.518611, 13.408333)];
    HereLocationItem *locationItem1 = [[HereLocationItem alloc] initWithTitle:@"Berlin Hauptbahnhof" coordinate:CLLocationCoordinate2DMake(52.518611, 13.408333)];
    HereLocationItem *locationItem2 = [[HereLocationItem alloc] initWithTitle:@"Berliner Siegessäule" coordinate:CLLocationCoordinate2DMake(52.514444, 13.35)];
    HereLocationItem *locationItem3 = [[HereLocationItem alloc] initWithTitle:@"Schloss Bellevue" coordinate:CLLocationCoordinate2DMake(52.5175, 13.353333)];
    HereLocationItem *locationItem4 = [[HereLocationItem alloc] initWithTitle:@"Zoologischer Garten Berlin" coordinate:CLLocationCoordinate2DMake(52.508087, 13.337793)];
    self.locationItems = @[locationItem0, locationItem1, locationItem2, locationItem3, locationItem4];
}

- (void)retrieveSearchResults
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.5233, 13.4127);   // Alexanderplatz
    NSString *query = self.searchController.searchBar.text;
    [self.hereClient retrieveSearchResultsWithCoordinate:coordinate query:query completionHandler:^(NSArray *locationItems, NSError *error) {
        self.locationItems = locationItems;
        [self.tableView reloadData];
    }];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(retrieveSearchResults) withObject:self afterDelay:0.3];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HereLocationItem *locationItem = self.locationItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = locationItem.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.completionBlock) {
        HereLocationItem *locationItem = self.locationItems[indexPath.row];
        self.completionBlock(locationItem);
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
