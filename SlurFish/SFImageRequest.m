//
//  SFImageRequest.m
//  SlurFish
//
//  Created by Nick Martin on 2/8/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SFImageRequest.h"

@implementation SFImageRequest
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
                   hasImage:(NSURL *)imageUrl{
    self = [super init];
    if (self) {
        _requestQueue = @{indexPath : [NSURLRequest requestWithURL:imageUrl]};
    }
    return self;
}

- (instancetype)initWithRequests:(NSDictionary *)imageRequests{
    self = [super init];
    if (self) {
        NSMutableDictionary *mutableQueue = [NSMutableDictionary dictionary];
        for(NSURL *url in [imageRequests allValues]){
            if([mutableQueue objectForKey:url] == nil){
                NSMutableSet *indexPathsForRequest = [NSMutableSet setWithArray:[imageRequests allKeysForObject:url]];
                [mutableQueue setObject:indexPathsForRequest forKey:url];
            }
        }
        _requestQueue = [NSDictionary dictionaryWithDictionary:mutableQueue];
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(void (^)(NSSet *indexPaths, UIImage *image))success
                              failure:(void (^)(NSError *error))failure{
    _imageDownloadComplete = success;
    _imageDownloadFailure = failure;
}
@end
