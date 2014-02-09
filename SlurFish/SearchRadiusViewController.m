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

- (void)viewDidLoad
{
    [self showSearchOverlay];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSearchOverlay{
    UIView *searchRadiusView = [UIView new];
    searchRadiusView.frame = self.view.frame;
    [self.view addSubview:searchRadiusView];
}

-(void)addCircleOverlayAtUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000);
    [_mapView setRegion:region animated:YES];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:1000];
    [_mapView addOverlay:circle];
}

#pragma mark - Map View Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //User location annotation
    if([annotation isKindOfClass:[MKUserLocation class]]){
        //[self addCircleOverlayAtUserLocation:annotation];
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];

    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

#pragma mark - UIResponder Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
