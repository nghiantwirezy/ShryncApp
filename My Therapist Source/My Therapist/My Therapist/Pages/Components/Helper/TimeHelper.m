//
//  TimeHelper.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "TimeHelper.h"
#define AGO @"ago"
#define ONE_MINUTE @"1 minute"
#define MINUTES @"minutes"
#define ONE_HOUR @"1 hour"
#define HOURS @"hours"
#define ONE_DAY @"1 day"
#define DAYS @"days"
#define ONE_MONTH @"1 month"
#define MONTHS @"months"
#define YEARS @"more than a year"
#define LESS_THAN_ONE_MINUTE @"Less than one minute"

@implementation TimeHelper
+(NSString *)timeFromTimeInterval:(NSTimeInterval )time{
    NSString *timeString = nil;
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    double delta = now - time;
    if (delta < 60) {
        timeString = [NSString stringWithFormat:@"%@ %@", LESS_THAN_ONE_MINUTE, AGO];
    } else if (delta < 120) {
        timeString = [NSString stringWithFormat:@"%@ %@", ONE_MINUTE, AGO];
    } else if (delta < 3600) {
        timeString = [NSString stringWithFormat:@"%ld %@ %@", lround(delta / 60), MINUTES, AGO];
    } else if (delta < 3600 * 2) {
        timeString = [NSString stringWithFormat:@"%@ %@", ONE_HOUR, AGO];
    } else if (delta < 3600 * 24) {
        timeString = [NSString stringWithFormat:@"%ld %@ %@", lround(delta / 3600), HOURS, AGO];
    } else if (delta < 3600 * 24 * 2) {
        timeString = [NSString stringWithFormat:@"%@ %@", ONE_DAY, AGO];
    } else if (delta < 3600 * 24 * 30) {
        timeString = [NSString stringWithFormat:@"%ld %@ %@", lround(delta / (3600 * 24)), DAYS, AGO];
    } else if (delta < 3600 * 24 * 30 * 2) {
        timeString = [NSString stringWithFormat:@"%@ %@", ONE_MONTH, AGO];
    } else if (delta < 3600 * 24 * 365) {
        timeString = [NSString stringWithFormat:@"%ld %@ %@", lround(delta / (3600 * 24 * 30)), MONTHS, AGO];
    } else {
        timeString = [NSString stringWithFormat:@"%@ %@", YEARS, AGO];
    }
    return timeString;
}

@end
