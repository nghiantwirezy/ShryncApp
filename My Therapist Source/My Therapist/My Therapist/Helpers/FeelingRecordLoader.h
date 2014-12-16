//
//  FeelingRecordLoader.h
//  My Therapist
//
//  Created by Yexiong Feng on 4/6/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface FeelingRecordLoader : NSObject

@property (weak, nonatomic) MBProgressHUD *hud;

- (NSString *)endpoint;
- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token endTime:(NSTimeInterval)endTime count:(NSUInteger)count andUserId:(NSString *)userId;
- (NSArray *)getSerializedFeelingRecordsFromResponse:(id)responseObject;

- (void)loadRecordsWithCount:(NSUInteger)count andUserId:(NSString *)userId before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure;

- (void)loadRecordsWithEndTime:(NSTimeInterval)endTime count:(NSUInteger)count withUserId:(NSString *)userId before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure;
//Edit 2-10
//- (NSString *)endpoint;
//- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token endTime:(NSTimeInterval)endTime count:(NSUInteger)count;
//- (NSArray *)getSerializedFeelingRecordsFromResponse:(id)responseObject;
//
//- (void)loadRecordsWithCount:(NSUInteger)count before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure;
//
//- (void)loadRecordsWithEndTime:(NSTimeInterval)endTime count:(NSUInteger)count before:(void (^)(void))before success:(void (^)(NSArray *, BOOL))success failure:(void (^)(NSInteger))failure;

@end
