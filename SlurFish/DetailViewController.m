//
//  DetailViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreLocation/CLLocation.h>
#import "SFPubLocation.h"
#import "SFPubAnnotation.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setPubItem:(Pub *)pub
{
    if (_pub != pub) {
        _pub = pub;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (_pub) {
        self.detailDescriptionLabel.text = [_pub name];
    }
    double lat = _pub.location.lat;
    double lng = _pub.location.lng;
    CLLocationCoordinate2D pubCoordinate = CLLocationCoordinate2DMake(lat, lng);
    SFPubAnnotation *pubAnnotation = [[SFPubAnnotation alloc] initWithCoordinate:pubCoordinate];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng) animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pubCoordinate, 350, 350);
    [_mapView setRegion:region animated:YES];
    [_mapView addAnnotation:pubAnnotation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
