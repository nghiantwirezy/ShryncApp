//
//  BaseServices.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "BaseServices.h"

#define TIME_OUT_INTERVAL 10
#define DETAIL_FEELING_ENDPOINT @"https://secure.shrync.com/api/feelings/detail"

@implementation BaseServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    }
    return manager;
}

+(void)requestByMethod:(NSString*)method withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest *request = [[BaseServices sharedManager].requestSerializer requestWithMethod:method URLString:DETAIL_FEELING_ENDPOINT parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[BaseServices sharedManager] HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              
                                                              if (success) {
                                                                  success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                                                              }
                                                              
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              
                                                              NSLog(@"%@",[operation responseString]);
                                                              
                                                              if (error.code == NSURLErrorCancelled) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorNotConnectedToInternet) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorTimedOut) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
#ifdef APPDEBUG
                                                              [APP_DELEGATE alertView:@"Error" withMessage:@"Somethings was wrong, please contact to Developer" andButton:@"OK"];
#endif
                                                          CALL_FAILURE:
                                                              if (failure) {
                                                                  failure(operation,error);
                                                              }
                                                              
                                                          }];
    [[BaseServices sharedManager].operationQueue addOperation:operation];
    
}


#pragma mark - Message Services

+ (void)updateCommentsWithParame:(NSDictionary *)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [BaseServices requestByMethod:@"GET" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
    }];
    


}

+(id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}
@end
