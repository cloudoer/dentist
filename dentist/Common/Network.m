//
//  Network.m
//  beauty
//
//  Created by xiaoyuan wang on 3/26/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"

@implementation Network

+ (void)httpGetPathWithCache:(NSString *)wholePath
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wholePath] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure(error);
    }];
    
    [operation start];
}

+ (void)httpGetPath:(NSString *)getPath
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError *error))failure
{
    NSString *wholePath = [NSString stringWithFormat:@"%@%@", BaseURLString, getPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wholePath]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self httpGetPathWithCache:wholePath success:success failure:failure];
    }];
    
    [operation start];
}

+ (void)httpPostPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(NSDictionary *responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manager POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);;
    }];
}

+ (BOOL)statusOKInResponse:(NSDictionary *)response
{
    int statusStr = [response[@"status"] intValue];
    return (statusStr == 0);
}

@end
