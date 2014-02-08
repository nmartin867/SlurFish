//
//  SFPubMapOverlay.m
//  SlurFish
//
//  Created by Nick Martin on 2/7/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SFPubMapOverlay.h"
#import "Pub.h"


@implementation SFPubMapOverlay

@synthesize boundingMapRect = _boundingMapRect;
@synthesize coordinate = _coordinate;

- (instancetype)initWithPub:(Pub *)pub{
    self = [super init];
    if (self) {
        //_boundingMapRect = park.overlayBoundingMapRect;
        //_coordinate = pub.l
    }
    
    return self;
    
}
@end
