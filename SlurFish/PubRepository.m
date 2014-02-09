//
//  PubRepository.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubRepository.h"
#import "AFHTTPRequestOperationManager.h"
#import "Pub.h"
#import "ConfigurationManager.h"
#import "SFPubLocation.h"
#import "SFImageDownloader.h"


@interface PubRepository(){}
@property(nonatomic, strong)AFHTTPRequestOperationManager *httpRequestManager;
@property(nonatomic, strong)ConfigurationManager *settings;
@end

@implementation PubRepository
@synthesize httpRequestManager = _httpRequestManager;
@synthesize settings = _settings;

-(AFHTTPRequestOperationManager *)httpRequestManager{
    if(_httpRequestManager == nil){
        _httpRequestManager = [AFHTTPRequestOperationManager manager];
    }
    return _httpRequestManager;
}

-(ConfigurationManager *)settings{
    if(_settings == nil){
        _settings = [[ConfigurationManager alloc]init];
    }
    return _settings;
}

-(SFPubLocation *)parseLocationResult:(NSDictionary *)result{
    SFPubLocation *pubLocation = [SFPubLocation new];
    pubLocation.address = result[@"address"];
    pubLocation.city = result[@"city"];
    pubLocation.state = result[@"state"];
    pubLocation.zip = result[@"postalCode"];
    pubLocation.distance = result[@"distance"];
    pubLocation.lat = [(NSNumber *)result[@"lat"] doubleValue];
    pubLocation.lng = [(NSNumber *)result[@"lng"] doubleValue];
    return pubLocation;
}

-(NSURL *)createCategoryIconUrlWithPrefix:(NSString *)iconPrefix suffix:(NSString *)iconSuffix{
    NSString *urlString = [NSString stringWithFormat:@"%@32%@",iconPrefix, iconSuffix];
    return [NSURL URLWithString:urlString];
}

-(void) getPubsLongitude:(double)longitude
             andLatitude:(double)latitude
               onSuccess:(PubSearchRequestSuccess)successBlock
                 onError:(PubSearchRequestError)errorBlock{
    NSDictionary *longLatQueryParam = @{
                                        @"v" : [self.settings apiVersion],
                                        @"query":@"bar",
                                        @"ll":[NSString stringWithFormat:@"%lf,%lf",latitude, longitude],
                                        @"client_id":[self.settings appId],
                                        @"client_secret": [self.settings appSecret],
                                        };
 
    [self.httpRequestManager GET:[self.settings apiBaseUrl] parameters:longLatQueryParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject[@"response"];
        successBlock([self formatPubSearchResults:response]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSMutableArray *)formatPubSearchResults:(NSDictionary *)pubResults{
    NSMutableArray *pubs = [NSMutableArray array];
    for(NSDictionary *venue in pubResults[@"venues"]){
        Pub *pub = [Pub new];
        pub.name =  venue[@"name"];
        for(NSDictionary *category in venue[@"categories"]){
            if([category[@"primary"] boolValue] == YES){
                pub.category = category[@"name"];
                NSDictionary *icon = category[@"icon"];
                pub.categoryIconUrl = [self createCategoryIconUrlWithPrefix:icon[@"prefix"] suffix:icon[@"suffix"]];
                break;
            }
        }
        NSDictionary *locationResult = venue[@"location"];
        pub.location = [self parseLocationResult:locationResult];
        [pubs addObject:pub];
    }
    return pubs;
}
@end
