//
//  LocationProvider.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocationProvider : NSObject <CLLocationManagerDelegate>

typedef void (^UserLocationSuccess)(CLLocation *userLocation);
typedef void (^UserLocationError)(NSError *error);
-(void)getUserLocationWithSuccess:(UserLocationSuccess)success error:(UserLocationError)error;

@end
