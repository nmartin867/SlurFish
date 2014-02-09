//
//  SFImageRequest.h
//  SlurFish
//
//  Created by Nick Martin on 2/8/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFImageRequest : NSObject
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath hasImage:(NSURL *)imageUrl;
- (instancetype)initWithRequests:(NSDictionary *)imageRequests;
- (void)setCompletionBlockWithSuccess:(void (^)(NSSet *indexPaths, UIImage *image))success failure:(void (^)(NSError *error))failure;
typedef void (^SFImageDownloadComplete)(NSSet *indexPath, UIImage *image);
typedef void (^SFImageDownloadFailure) (NSError *error);
@property(readonly, nonatomic, strong) NSDictionary *requestQueue;
@property(readonly, nonatomic, strong) SFImageDownloadComplete imageDownloadComplete;
@property(readonly, nonatomic, strong) SFImageDownloadFailure imageDownloadFailure;

@end
