//
//  PubProvider.h
//  SlurFish
//
//  Created by Nick Martin on 2/16/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PubSearchRequestSuccess)(NSMutableArray *pubs);
typedef void (^PubSearchRequestError)(NSError *error);

@protocol PubProvider <NSObject>
-(void) getPubsLongitude:(double)longitude
             andLatitude:(double)latitude
               onSuccess:(PubSearchRequestSuccess)successBlock
                 onError:(PubSearchRequestError)errorBlock;
@end
