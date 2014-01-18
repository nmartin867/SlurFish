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
    return [self.settings[@"FourSquare"] objectForKey:@"AppID"];
}

-(NSString *)appSecret{
    return [self.settings[@"FourSquare"] objectForKey:@"AppSecret"];
}
@end
