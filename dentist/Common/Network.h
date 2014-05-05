//
//  Network.h
//  beauty
//
//  Created by xiaoyuan wang on 3/26/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

+ (void)httpGetPath:(NSString *)path
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError *error))failure;

+ (void)httpPostPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(NSDictionary *responseObject))success
             failure:(void (^)(NSError *error))failure;

+ (BOOL)statusOKInResponse:(NSDictionary *)response;
+ (NSString *)statusErrorDes:(NSDictionary *)response;

@end
