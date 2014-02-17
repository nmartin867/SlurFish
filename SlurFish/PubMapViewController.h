//
//  DetailViewController.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Pub.h"

@interface PubMapViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Pub *pub;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end
