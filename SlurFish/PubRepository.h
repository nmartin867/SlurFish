//
//  PubRepository.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubProvider.h"

@interface PubRepository : NSObject <PubProvider>

-(void) getPubsLongitude:(double)longitude
             andLatitude:(double)latitude
                     onSuccess:(PubSearchRequestSuccess)successBlock
                       onError:(PubSearchRequestError)errorBlock;
@end
