//
//  PublicFeelingRecordLoader.m
//  My Therapist
//
//  Created by Yexiong Feng on 8/11/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "PublicFeelingRecordLoader.h"

#define GET_PUBLIC_FEELING_ENDPOINT_URL @"https://secure.shrync.com/api/feelings/getpublic"
#define LATITUDE_PARAM_KEY @"lat"
#define LONGITUDE_PARAM_KEY @"lng"
#define START_TIME_PARAM_KEY @"start"

@implementation PublicFeelingRecordLoader {
  CLLocationCoordinate2D _location;
}

- (NSString *)endpoint
{
  return GET_PUBLIC_FEELING_ENDPOINT_URL;
}

- (NSMutableDictionary *)buildParamsDictWithToken:(NSString *)token endTime:(NSTimeInterval)endTime count:(NSUInteger)count andUserId:(NSString *)userId
{
    NSMutableDictionary *dict = [super buildParamsDictWithToken:token endTime:endTime count:count andUserId:userId];
  //[dict setObject:[NSNumber numberWithDouble:_location.latitude] forKey:LATITUDE_PARAM_KEY];
  //[dict setObject:[NSNumber numberWithDouble:_location.longitude] forKey:LONGITUDE_PARAM_KEY];
  return dict;
}

- (NSArray *)getSerializedFeelingRecordsFromResponse:(id)responseObject
{
  return responseObject;
}

@end
