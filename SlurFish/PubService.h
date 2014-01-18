//
//  PubService.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubRepository.h"
#import <CoreLocation/CoreLocation.h>

@interface PubService : NSObject
-(void)getPubsWithCoordinate:(CLLocationCoordinate2D)coordinate
                        onSuccess:(PubSearchRequestSuccess)success
                          onError:(PubSearchRequestError)error;
@end
