//
//  SFPubMapOverlay.h
//  SlurFish
//
//  Created by Nick Martin on 2/7/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Pub;

@interface SFPubMapOverlay : NSObject <MKOverlay>
- (instancetype)initWithPub:(Pub *)pub;
@end
