//
//  LocationProvider.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "LocationProvider.h"
#import <CoreLocation/CoreLocation.h>
#import "ConfigurationManager.h"

@interface LocationProvider(){
    UserLocationSuccess _userLocationBlock;
    UserLocationError _userLocationErrorBlock;
    
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation LocationProvider
@synthesize locationManager = _locationManager;

-(CLLocationManager *)locationManager{
    if(_locationManager == nil){
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

-(void)getUserLocationWithSuccess:(UserLocationSuccess)success error:(UserLocationError)error{
    NSAssert(success != nil, @"getUserLocationWithSuccess:success was called without success block.");
    _userLocationBlock = success;
    
    if([ConfigurationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"Location Services not enabled.");
    }
    
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
     _userLocationBlock([locations lastObject]);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}


@end
