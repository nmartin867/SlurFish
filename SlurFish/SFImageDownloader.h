//
//  SFImageDownloader.h
//  SlurFish
//
//  Created by Nick Martin on 2/8/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFImageRequest;
@interface SFImageDownloader : NSObject
-(instancetype)initWithRequest:(SFImageRequest *)request;
-(void)start;
@end
