//
//  SFPubAnnotation.m
//  SlurFish
//
//  Created by Nick Martin on 2/7/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SFPubAnnotation.h"

@implementation SFPubAnnotation
@synthesize title = _title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

-(NSString *)title{
    return @"A Pub";
}
@end
