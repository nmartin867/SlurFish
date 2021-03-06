//
//  ConfigurationManager.h
//  SlurFish
//
//  Created by Nick Martin on 1/17/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationManager : NSObject
+(NSString *)appId;
+(NSString *)appSecret;
+(NSString *)apiBaseUrl;
+(NSString *)apiVersion;
+(NSString *)testFlightKey;
+(bool)canDialPhone;
+(bool)locationServicesEnabled;
@end
