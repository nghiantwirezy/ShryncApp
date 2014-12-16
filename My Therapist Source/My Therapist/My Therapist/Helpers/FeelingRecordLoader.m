//
//  FeelingRecordLoader.m
//  My Therapist
//
//  Created by Yexiong Feng on 4/6/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "FeelingRecordLoader.h"
#import "AFHTTPRequestOperationManager.h"
#import "FeelingRecord.h"
#import "UserSession.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define GET_FEELINGS_ENDPOINT @"https://secure.shrync.com/api/feelings/get"
#define GET_FEELINGS_TOKEN_PARAM @"token"
#define GET_FEELINGS_ENDTIME_PARAM @"end"
#define GET_FEELINGS_COUNT_PARAM @"count"
#define GET_FEELINGS_USERID @"userid"

#define END_TIME 32503680000

#define GET_FEELINGS_RESULT_PARAM @"result"

#define ERROR_WRONG_TOKEN @"Session expired! Please login again."

static UIImageView *_customView;

@implementation FeelingRecordLoader

+ (void)initialize
{
  _customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no.png"]];
}

- (void)returnToLogin
{
  [_hud hide:YES];
  [UserSession signOut];
  
  AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  [delegate navigateToLandingPage];
}

- (NSString *)endpoint
{
  return GET_FEELINGS_ENDPOINT;
}

- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token endTime:(NSTimeInterval)endTime count:(NSUInteger)count andUserId:(NSString *)userId
{
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [dict setObject:token forKey:GET_FEELINGS_TOKEN_PARAM];
  [dict setObject:[NSNumber numberWithDouble:endTime] forKey:GET_FEELINGS_ENDTIME_PARAM];
  [dict setObject:[NSNumber numberWithInteger:(count + 1)] forKey:GET_FEELINGS_COUNT_PARAM];
  [dict setObject:userId forKey:GET_FEELINGS_USERID];
 
  return dict;
}

- (NSArray *)getSerializedFeelingRecordsFromResponse:(id)responseObject
{
  NSArray *serializedFeelingRecords = [responseObject objectForKey:GET_FEELINGS_RESULT_PARAM];
  if (serializedFeelingRecords == (id)[NSNull null]) {
    serializedFeelingRecords = nil;
  }
  return serializedFeelingRecords;
}

- (void)loadRecordsWithEndTime:(NSTimeInterval)endTime count:(NSUInteger)count withUserId:(NSString *)userId before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure
{
  UserSession *userSession = [UserSession currentSession];
  if (userSession == nil || userSession.isGuestSession) {
    return;
  }

  NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken endTime:endTime count:count andUserId:userId];
    NSLog(@"parram = %@",parameters);
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:[self endpoint] parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *serializedFeelingRecords = [self getSerializedFeelingRecordsFromResponse:responseObject];
         
         NSMutableArray *feelingRecords = [[NSMutableArray alloc] init];
         for (int i = 0; i < MIN((NSInteger)serializedFeelingRecords.count, (NSInteger)count); ++i) {
           NSDictionary *dict = [serializedFeelingRecords objectAtIndex:i];
           FeelingRecord *feelingRecord = [FeelingRecord fromDictionary:dict];
             if (!(![feelingRecord.userId isEqualToString:[UserSession currentSession].userId] && !feelingRecord.isPublic)) {
                 [feelingRecords addObject:feelingRecord];
             }
         }
         
         if (success) {
           success(feelingRecords, count < serializedFeelingRecords.count);
         }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
           failure(operation.response.statusCode);
         }
         
         _hud.mode = MBProgressHUDModeCustomView;
         _hud.customView = _customView;
         
         if (operation.response.statusCode == 501) {
           _hud.labelText = NSLocalizedString(ERROR_WRONG_TOKEN, nil);
           [_hud show:YES];
           [self performSelector:@selector(returnToLogin) withObject:nil afterDelay:2.0];
         } else {
           [_hud show:YES];
           [_hud hide:YES afterDelay:2.0];
         }
       }];
}

- (void)loadRecordsWithCount:(NSUInteger)count andUserId:(NSString *)userId before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure{
  [self loadRecordsWithEndTime:END_TIME count:count withUserId:userId before:before success:success failure:failure];
}

//Edit 2-10

//- (void)loadRecordsWithEndTime:(NSTimeInterval)endTime count:(NSUInteger)count before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure
//{
//    UserSession *userSession = [UserSession currentSession];
//    if (userSession == nil || userSession.isGuestSession) {
//        return;
//    }
//    
//    NSDictionary *parameters = [self buildParamsDictWithToken:userSession.sessionToken endTime:endTime count:count];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    [manager GET:[self endpoint] parameters:parameters
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSArray *serializedFeelingRecords = [self getSerializedFeelingRecordsFromResponse:responseObject];
//             
//             NSMutableArray *feelingRecords = [[NSMutableArray alloc] init];
//             for (int i = 0; i < MIN((NSInteger)serializedFeelingRecords.count, (NSInteger)count); ++i) {
//                 NSDictionary *dict = [serializedFeelingRecords objectAtIndex:i];
//                 FeelingRecord *feelingRecord = [FeelingRecord fromDictionary:dict];
//                 [feelingRecords addObject:feelingRecord];
//             }
//             
//             if (success) {
//                 success(feelingRecords, count < serializedFeelingRecords.count);
//             }
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             if (failure) {
//                 failure(operation.response.statusCode);
//             }
//             
//             _hud.mode = MBProgressHUDModeCustomView;
//             _hud.customView = _customView;
//             
//             if (operation.response.statusCode == 501) {
//                 _hud.labelText = NSLocalizedString(ERROR_WRONG_TOKEN, nil);
//                 [_hud show:YES];
//                 [self performSelector:@selector(returnToLogin) withObject:nil afterDelay:2.0];
//             } else {
//                 [_hud show:YES];
//                 [_hud hide:YES afterDelay:2.0];
//             }
//         }];
//}
//
//- (void)loadRecordsWithCount:(NSUInteger)count before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure
//{
//    [self loadRecordsWithEndTime:END_TIME count:count before:before success:success failure:failure];
//}

@end
