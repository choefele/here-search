//
//  MapViewController.m
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "MapViewController.h"

#import "ItineraryModel.h"
#import "HereClient.h"

static NSString *APP_ID = @"DemoAppId01082013GAL";
static NSString *APP_CODE = @"AJKnXv84fjrb0KIHawS0Tg";

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) HereClient *hereClient;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hereClient = [[HereClient alloc] initWithAppID:APP_ID appCode:APP_CODE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.itineraryModel.locationItems];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.hereClient retrieveRouteWithLocationItems:self.itineraryModel.locationItems completionHandler:^(MKPolyline *polyline, NSError *error) {
        if (polyline) {
            [self.mapView addOverlay:polyline];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapView showAnnotations:self.itineraryModel.locationItems animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineRenderer *polyLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    polyLineRenderer.lineWidth = 2;
    polyLineRenderer.strokeColor = UIColor.blueColor;
    
    return polyLineRenderer;
}

@end
