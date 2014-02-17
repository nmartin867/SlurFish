//
//  SearchRadiusViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/18/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SearchRadiusViewController.h"
#import "LocationProvider.h"
#import "UIColor+SlurFish.h"

@interface SearchRadiusViewController (){
    float _lastScale;
    MKCircle *_searchRadiusOverlay;
    CLLocation *_userLocation;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SearchRadiusViewController

const static float sliderMin = 1609.34;
const static float sliderMax = 32186.9;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _radiusSlider.minimumValue = sliderMin;
    _radiusSlider.maximumValue = sliderMax;
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

-(void)addCircleOverlayAtUserLocation:(CLLocation *)userLocation{
    _userLocation = userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 3000, 3000);
    [_mapView setRegion:region animated:YES];
    _searchRadiusOverlay = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:500];
    [_mapView addOverlay:_searchRadiusOverlay];
}
- (IBAction)sliderChange:(id)sender {
    [_mapView removeOverlay:_searchRadiusOverlay];
    _searchRadiusOverlay = [MKCircle circleWithCenterCoordinate:_userLocation.coordinate radius:_radiusSlider.value];
    [_mapView addOverlay:_searchRadiusOverlay];
}


#pragma mark - Map View Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //User location annotation
    if([annotation isKindOfClass:[MKUserLocation class]]){
        MKUserLocation *userLocation = (MKUserLocation *)annotation;
        [self addCircleOverlayAtUserLocation:userLocation.location];
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];

    circleView.strokeColor = [UIColor cellTextColor];
    circleView.fillColor = [UIColor HudColor];
    return circleView;
}





@end
