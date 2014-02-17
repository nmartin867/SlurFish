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

@interface PubMapViewController (){
    NSMutableDictionary *_pubDetail;
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
    self.view.backgroundColor = [UIColor backgroundColor];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.navigationItem.title = _pub.name;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton addTarget:self action:@selector(goBack)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    _pubDetail = [NSMutableDictionary dictionary];
    if(_pub.phoneNumber != nil){
        [_pubDetail setObject:_pub.phoneNumber forKey:@"phoneNumber"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [mapView deselectAnnotation:view.annotation animated:YES];
    NSLog(@"Tap!");
    /*DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
    controller.annotation = view.annotation; // it's useful to have property in your view controller for whatever data it needs to present the annotation's details
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.delegate = self;
    
    [self.popover presentPopoverFromRect:view.frame
                                  inView:view.superview
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];*/
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor cellTextColor];
    cell.detailTextLabel.textColor = [UIColor cellTextColor];
    NSString *key = [_pubDetail allKeys][indexPath.row];
    cell.textLabel.text = [_pubDetail objectForKey:key];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //_selectedPub = [_pubs objectAtIndex:indexPath.row];
    //[self performSegueWithIdentifier:@"PubMap" sender:self];
}

@end
