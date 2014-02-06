//
//  ConfigurationManager.m
//  SlurFish
//
//  Created by Nick Martin on 1/17/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "ConfigurationManager.h"
@interface ConfigurationManager()
@property(nonatomic, strong) NSMutableDictionary *settings;
@end

@implementation ConfigurationManager
@synthesize settings = _settings;

-(NSMutableDictionary *)settings{
    if(_settings == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        _settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    return _settings;
}

-(NSString *)appId{
    return self.settings[@"AppID"];
}

-(NSString *)appSecret{
    return self.settings[@"AppSecret"];
}

-(NSString *)apiBaseUrl{
    return self.settings[@"API_Base_URL"];
}

-(NSString *)apiVersion{
    return self.settings[@"API_Version"];
}
@end
