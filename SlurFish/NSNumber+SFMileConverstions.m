//
//  NSNumber+SFMileConverstions.m
//  SlurFish
//
//  Created by Nick Martin on 2/16/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "NSNumber+SFMileConverstions.h"

@implementation NSNumber (SFMileConverstions)
const static float metersInMile = 1609.344;

+(float)milesWithMeters:(float)meters{
    return meters / metersInMile;
}
@end
