//
//  PubRepository.h
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubRepository : NSObject
typedef void (^PubSearchRequestSuccess)(NSMutableArray *pubs);
typedef void (^PubSearchRequestError)(NSError *error);
-(void) getPubsLongitude:(double)longitude
             andLatitude:(double)latitude
                     onSuccess:(PubSearchRequestSuccess)successBlock
                       onError:(PubSearchRequestError)errorBlock;
@end
