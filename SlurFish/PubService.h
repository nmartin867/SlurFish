//
//  PubService.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PubProvider.h"

@interface PubService : NSObject

-(instancetype)initWithPubRepository:(id<PubProvider>)pubRepository;
-(void)getPubsWithCoordinate:(CLLocationCoordinate2D)coordinate
                        onSuccess:(PubSearchRequestSuccess)success
                          onError:(PubSearchRequestError)error;
@end
