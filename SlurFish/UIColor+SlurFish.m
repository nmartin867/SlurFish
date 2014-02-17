//
//  UIColor+SlurFish.m
//  SlurFish
//
//  Created by Nick Martin on 2/16/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "UIColor+SlurFish.h"

@implementation UIColor (SlurFish)
+(UIColor *)navigationBackgroupColor{
    return[self colorWithRed:(41/255.0) green:(41/255.0) blue:(41/255.0) alpha:1.0];
}
+(UIColor *)backgroundColor{
    return[self colorWithRed:(61/255.0) green:(61/255.0) blue:(61/255.0) alpha:1.0];
}
+(UIColor *)cellTextColor{
    return [UIColor colorWithRed:255/255.0 green:89/255.0 blue:0 alpha:1.0];
}
@end
