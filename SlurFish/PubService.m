//
//  PubService.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubService.h"
@interface PubService(){
 id<PubProvider> _pubRepository;
}
@end

@implementation PubService


-(instancetype)initWithPubRepository:(id<PubProvider>)pubRepository{
    
        self = [super init];
        if (self) {
            _pubRepository = pubRepository;
        }
        return self;
    
}


-(void)getPubsWithCoordinate:(CLLocationCoordinate2D)coordinate
                   onSuccess:(PubSearchRequestSuccess)success
                     onError:(PubSearchRequestError)error{
    [_pubRepository getPubsLongitude:coordinate.longitude andLatitude:coordinate.latitude onSuccess:success onError:error];
}
@end
