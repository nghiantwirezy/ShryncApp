//
//  BaseServices.h
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MessageBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface BaseServices : NSObject

+(AFHTTPRequestOperationManager*)sharedManager;

+ (void)updateCommentsWithParame:(NSDictionary *)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+(void)requestByMethod:(NSString*)method withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
