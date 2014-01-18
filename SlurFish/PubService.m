//
//  PubService.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubService.h"
@interface PubService(){}
@property(nonatomic, strong)PubRepository *pubRepository;
@end

@implementation PubService
@synthesize pubRepository = _pubRepository;

-(PubRepository *)pubRepository{
    if(_pubRepository == nil){
        _pubRepository = [[PubRepository alloc]init];
    }
    return _pubRepository;
}

-(void)getPubsWithCoordinate:(CLLocationCoordinate2D)coordinate
                   onSuccess:(PubSearchRequestSuccess)success
                     onError:(PubSearchRequestError)error{
    [self.pubRepository getPubsLongitude:coordinate.longitude andLatitude:coordinate.latitude onSuccess:success onError:error];
}
@end
