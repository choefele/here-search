//
//  MapViewController.m
//  Here Search
//
//  Created by Claus Höfele on 01.03.15.
//  Copyright (c) 2015 Claus Höfele. All rights reserved.
//

#import "MapViewController.h"

#import "ItineraryModel.h"

#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.itineraryModel.locationItems];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:self.itineraryModel.polyline];
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
