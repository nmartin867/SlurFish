//
//  SFPubLocation.m
//  SlurFish
//
//  Created by Nick Martin on 2/7/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SFPubLocation.h"

@implementation SFPubLocation

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(_lat, _lng);
}
@end
