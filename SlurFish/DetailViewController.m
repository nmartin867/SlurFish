//
//  DetailViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreLocation/CLLocation.h>

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setPubItem:(Pub *)pub
{
    if (_pub != pub) {
        _pub= pub;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.pub) {
        self.detailDescriptionLabel.text = [self.pub name];
    }
    double lat = [self.pub.location[@"lat"] doubleValue];
    double lng = [self.pub.location[@"lng"] doubleValue];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng) animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat, lng), 350, 350);
    [self.mapView setRegion:region animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
