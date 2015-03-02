//
//  ViewController.m
//  Here Search
//
//  Created by Claus Höfele on 28.02.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "ViewController.h"

#import "ItineraryModel.h"
#import "MapViewController.h"
#import "ListViewController.h"
#import "AddLocationItemViewController.h"
#import "HereLocationItem.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapViewControllerView;
@property (weak, nonatomic) IBOutlet UIView *listViewControllerView;

@property (nonatomic) ItineraryModel *itineraryModel;
@property (nonatomic) MapViewController *mapViewController;
@property (nonatomic) ListViewController *listViewController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itineraryModel = [[ItineraryModel alloc] initWithAppGroupName:@"group.com.claushoefele.HereSearch"];

    self.mapViewController.itineraryModel = self.itineraryModel;
    self.listViewController.itineraryModel = self.itineraryModel;
    self.listViewControllerView.hidden = YES;
}

- (void)setMapViewVisible:(BOOL)mapViewVisible
{
    [self.mapViewController beginAppearanceTransition:mapViewVisible animated:YES];
    self.mapViewControllerView.hidden = !mapViewVisible;
    [self.mapViewController endAppearanceTransition];

    [self.listViewController beginAppearanceTransition:!mapViewVisible animated:YES];
    self.listViewControllerView.hidden = mapViewVisible;
    [self.listViewController endAppearanceTransition];
    
    self.navigationItem.leftBarButtonItem = mapViewVisible ? nil : self.listViewController.editButtonItem;
}

- (IBAction)changeView:(UISegmentedControl *)sender
{
    [self setMapViewVisible:(sender.selectedSegmentIndex == 0)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMapViewController"]) {
        self.mapViewController = (MapViewController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"toListViewController"]) {
        self.listViewController = (ListViewController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"toAddLocationItemViewController"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        AddLocationItemViewController *addLocationItemViewController = navigationController.viewControllers.firstObject;
        addLocationItemViewController.completionBlock = ^(HereLocationItem *locationItem) {
            [self.itineraryModel appendLocationItem:locationItem];
        };
    }
}

@end
