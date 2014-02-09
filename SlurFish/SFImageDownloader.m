//
//  SFImageDownloader.m
//  SlurFish
//
//  Created by Nick Martin on 2/8/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "SFImageDownloader.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "SFImageRequest.h"

@interface SFImageDownloader(){
    SFImageRequest *_request;
    NSDictionary *_currentRequest;
}
@end

@implementation SFImageDownloader
-(instancetype)initWithRequest:(SFImageRequest *)request{
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}

-(void)start{
    for(NSURL *url in _request.requestQueue){
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSSet *indexPaths = [_request.requestQueue objectForKey:operation.request.URL];
            _request.imageDownloadComplete(indexPaths, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _request.imageDownloadFailure(error);
        }];
        [requestOperation start];
    }
}

@end
