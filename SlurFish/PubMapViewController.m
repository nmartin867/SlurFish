//
//  DetailViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubMapViewController.h"
#import <CoreLocation/CLLocation.h>
#import "SFPubLocation.h"
#import "SFPubAnnotation.h"
#import "UIColor+SlurFish.h"
#import "ConfigurationManager.h"
#import "SFPopOverViewController.h"
#import "TestFlight.h"

@interface PubMapViewController (){
    NSMutableDictionary *_pubDetail;
    UIPopoverController *_pubPopupViewController;
}

@end

@implementation PubMapViewController

#pragma mark - Managing the detail item


- (void)configureMap
{
    SFPubAnnotation *pubAnnotation = [[SFPubAnnotation alloc] initWithCoordinate:_pub.location.coordinate];
    [_mapView setCenterCoordinate:_pub.location.coordinate animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_pub.location.coordinate, 350, 350);
    [_mapView setRegion:region animated:YES];
    [_mapView addAnnotation:pubAnnotation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureMap];
    [self setAddressText];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.navigationItem.title = _pub.name;
    
    self.addressLbl.textColor = [UIColor whiteColor];
    self.addressLbl.textAlignment = NSTextAlignmentCenter;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton addTarget:self action:@selector(goBack)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
 
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    _pubDetail = [NSMutableDictionary dictionary];
    [_pubDetail setObject:_pub.location forKey:@"pubLocation"];
    if(_pub.phoneNumber != nil){
        [_pubDetail setObject:_pub.formatedPhoneNumber forKey:@"formattedPhone"];
    }
    
}

-(void) setAddressText{
    NSString *address = (_pub.location.address == nil) ? @"" : _pub.location.address;
    NSString *city = (_pub.location.city == nil) ? @"" : _pub.location.city;
    NSString *state = (_pub.location.state == nil) ? @"" : _pub.location.state;
    self.addressLbl.text = [NSString stringWithFormat:@"%@ %@, %@",address, city, state];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openDirections{
    [TestFlight passCheckpoint:@"Open Directions Checkpoint"];
    CLLocationCoordinate2D pubLocation = _pub.location.coordinate;
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: pubLocation addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = _pub.name;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[SFPubAnnotation class]]){
        static NSString *identifier = @"PubAnnotation";
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"PubMapAnnotation.png"];
        
        return annotationView;
    }
    return nil;
}


#pragma mark - UITableViewDelegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_pubDetail allKeys]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PubDetailIdentifier = @"PubDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PubDetailIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PubDetailIdentifier];
    }
   
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor cellTextColor];
    cell.detailTextLabel.textColor = [UIColor cellTextColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *key = [[_pubDetail allKeys] objectAtIndex:indexPath.row];
    
    if([key isEqualToString:@"formattedPhone"]){
        cell.imageView.image = [UIImage imageNamed:@"phone.png"];
        cell.textLabel.text = [_pubDetail objectForKey:@"formattedPhone"];
    }
    if([key isEqualToString:@"pubLocation"]){
        cell.imageView.image = [UIImage imageNamed:@"directions.png"];
        cell.textLabel.text = @"Get Directions";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [[_pubDetail allKeys] objectAtIndex:indexPath.row];
    if([key isEqualToString:@"formattedPhone"] && [ConfigurationManager canDialPhone]){
        [TestFlight passCheckpoint:@"Call Pub Checkpoint"];
            NSString *phoneNumber = [@"telprompt://" stringByAppendingString:_pub.phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }else{
        [self openDirections];
    }
}

@end
