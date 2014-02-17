//
//  SFPubLocation.h
//  SlurFish
//
//  Created by Nick Martin on 2/7/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface SFPubLocation : NSObject
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *zip;
@property(nonatomic, strong) NSNumber *distance;
@property(nonatomic) double lat;
@property(nonatomic) double lng;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@end

