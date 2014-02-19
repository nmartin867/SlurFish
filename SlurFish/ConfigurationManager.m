//
//  ConfigurationManager.m
//  SlurFish
//
//  Created by Nick Martin on 1/17/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "ConfigurationManager.h"
#import <MapKit/MapKit.h>

@interface ConfigurationManager()
@end

@implementation ConfigurationManager


+(NSMutableDictionary *)getSettings{
  
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

+(NSString *)appId{
    return [self getSettings][@"AppID"];
}

+(NSString *)appSecret{
    return [self getSettings][@"AppSecret"];
}

+(NSString *)apiBaseUrl{
    return [self getSettings][@"API_Base_URL"];
}

+(NSString *)apiVersion{
    return [self getSettings][@"API_Version"];
}

+(NSString *)testFlightKey{
    return[self getSettings][@"TestFlightKey"];
}

+(bool)canDialPhone{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
        return YES;
    } else {
        return NO;
    }
}

+(bool)locationServicesEnabled{
    if([CLLocationManager locationServicesEnabled]){
        return YES;
    }else{
        return NO;
    }
}
@end
