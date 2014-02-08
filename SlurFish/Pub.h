//
//  Pub.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFPubLocation;
@interface Pub : NSObject
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)SFPubLocation *location;
@property(nonatomic, strong)NSString *category;
@end
