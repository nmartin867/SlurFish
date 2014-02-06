//
//  SearchRadiusViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/18/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SearchRadiusViewController.h"
#import "LocationProvider.h"

@interface SearchRadiusViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SearchRadiusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map View Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *aView = nil;
    //User location annotation
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    // Handle any custom annotations.
    aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapPin"];
    if(aView){
        aView.annotation = annotation;
    } else {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:@"mapPin"];
    }
    return aView;
}

@end
