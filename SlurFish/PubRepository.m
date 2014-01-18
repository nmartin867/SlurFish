//
//  PubRepository.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubRepository.h"
#import "AFHTTPRequestOperationManager.h"
#import "constants.h"
#import "Pub.h"


@interface PubRepository(){}
@property(nonatomic, strong)AFHTTPRequestOperationManager *httpRequestManager;
@end

@implementation PubRepository
@synthesize httpRequestManager = _httpRequestManager;

-(AFHTTPRequestOperationManager *)httpRequestManager{
    if(_httpRequestManager == nil){
        _httpRequestManager = [AFHTTPRequestOperationManager manager];
    }
    return _httpRequestManager;
}

-(void) getPubsLongitude:(double)longitude
             andLatitude:(double)latitude
               onSuccess:(PubSearchRequestSuccess)successBlock
                 onError:(PubSearchRequestError)errorBlock{
    NSDictionary *longLatQueryParam = @{
                                        @"v" : @"20140112",
                                        @"query":@"bar",
                                        @"ll":[NSString stringWithFormat:@"%lf,%lf",latitude, longitude],
                                        @"client_id":@"",
                                        @"client_secret": @""
                                        };
    [self.httpRequestManager GET:kExplorerSearchBaseUrl parameters:longLatQueryParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject[@"response"];
        successBlock([self formatPubSearchResults:response]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSMutableArray *)formatPubSearchResults:(NSDictionary *)pubResults{
    NSMutableArray *pubs = [NSMutableArray array];
    for(NSDictionary *venue in pubResults[@"venues"]){
        Pub *pub = [[Pub alloc]init];
        pub.name =  venue[@"name"];
        if([[venue objectForKey:@"categories"]count] > 0){
            pub.category = [[venue[@"categories"] objectAtIndex:0]objectForKey:@"name"];
        }
        pub.location = venue[@"location"];
        [pubs addObject:pub];
    }
    return pubs;
}
@end
