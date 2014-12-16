//
//  FeelingRecord.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/13/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "FeelingRecord.h"
#import "Feeling.h"
#import "NSString+JSON.h"
#import "UserSession.h"
#import "NSDictionary+GetNull.h"
#import "NSDate+Helpers.h"
#import "CommentObject.h"
#import "BaseServices.h"

static NSArray *_activityNames;

@implementation FeelingRecord

+ (void)initialize
{
    NSArray *subStrings = [NAMES_ACTIVITY_FEELING_RECORD componentsSeparatedByString:@","];
    NSMutableArray *activityNames = [[NSMutableArray alloc] init];
    for (NSString *subString in subStrings) {
        [activityNames addObject:NSLocalizedString(subString, nil)];
    }
    _activityNames = activityNames;
}

+ (NSArray *)activityNames
{
    return _activityNames;
}

+ (NSString *)activityNameForIndex:(NSUInteger)index
{
    return [_activityNames objectAtIndex:index];
}

+ (FeelingRecord *)fromDictionary:(NSDictionary *)dictionary
{
    FeelingRecord *feelingRecord = [[FeelingRecord alloc] init];
    
    NSArray *feelingDicts = [dictionary objectForKeyNotNull:KEY_FEELINGS];
    NSMutableArray *feelings = [[NSMutableArray alloc] initWithCapacity:feelingDicts.count];
    for (NSDictionary *feelingDict in feelingDicts) {
        [feelings addObject:[Feeling fromJSONDictionary:feelingDict]];
    }
    feelingRecord.feelings = feelings;
    
    NSTimeInterval time = [[dictionary objectForKeyNotNull:KEY_TIME] doubleValue];
    feelingRecord.time = time;
    
    NSUInteger activityIndex = [[dictionary objectForKeyNotNull:KEY_ACTIVITY_INDEX] unsignedIntegerValue];
    feelingRecord.activityIndex = activityIndex;
    
    NSString *comment = [dictionary objectForKeyNotNull:KEY_COMMENT];
    feelingRecord.comment = comment;
    
    CLLocationCoordinate2D location;
    location.latitude = [[dictionary objectForKeyNotNull:KEY_LATITUDE] doubleValue];
    location.longitude = [[dictionary objectForKeyNotNull:KEY_LONGITUDE] doubleValue];
    feelingRecord.location = location;
    
    feelingRecord.thumbnailPath = [dictionary objectForKeyNotNull:KEY_THUMBNAIL];
    if (feelingRecord.thumbnailPath.length == 0) {
        feelingRecord.thumbnailPath = @"";
    }
    feelingRecord.code = [dictionary objectForKeyNotNull:KEY_CODE];
    
    feelingRecord.isPublic = [[dictionary objectForKeyNotNull:KEY_IS_PUBLIC] boolValue];
    
    feelingRecord.username = [dictionary objectForKeyNotNull:KEY_NICK_NAME];
    
    feelingRecord.userId = [dictionary objectForKeyNotNull:KEY_USER_ID];
    
    feelingRecord.city = [dictionary objectForKeyNotNull:KEY_CITY];
    
    feelingRecord.state = [dictionary objectForKeyNotNull:KEY_STATE];
    
    feelingRecord.recordId = [dictionary objectForKey:KEY_ID];
    
    feelingRecord.huggedByMe = NO;
    NSArray *huggerDicts = [dictionary objectForKeyNotNull:KEY_HUGGERS];
    if (huggerDicts.count > 0) {
        NSMutableArray *huggers = [[NSMutableArray alloc] init];
        NSString *myUserId = [UserSession currentSession].userId;
        for (NSDictionary *huggerDict in huggerDicts) {
            [huggers addObject:[huggerDict objectForKeyNotNull:KEY_NICK_NAME]];
            NSString *huggerId = [huggerDict objectForKeyNotNull:KEY_USER_ID];
            if ([myUserId caseInsensitiveCompare:huggerId] == NSOrderedSame) {
                feelingRecord.huggedByMe = YES;
            }
        }
        feelingRecord.huggers = huggers;
    }
    feelingRecord.huggerDict = [NSArray arrayWithArray:huggerDicts];
    
    feelingRecord.likedByMe = NO;
    NSArray *likerDicts = [dictionary objectForKeyNotNull:KEY_LIKERS];
    if (likerDicts.count > 0) {
        NSMutableArray *likers = [[NSMutableArray alloc] init];
        NSString *myUserId2 = [UserSession currentSession].userId;
        for (NSDictionary *likerDict in likerDicts) {
            [likers addObject:[likerDict objectForKeyNotNull:KEY_NICK_NAME]];
            NSString *likerId = [likerDict objectForKeyNotNull:KEY_USER_ID];
            if ([myUserId2 caseInsensitiveCompare:likerId] == NSOrderedSame) {
                feelingRecord.likedByMe = YES;
            }
        }
        feelingRecord.likers = likers;
    }
    
    feelingRecord.likerDict = [NSArray arrayWithArray:likerDicts];
    
    NSArray *commentDicts = [dictionary objectForKeyNotNull:KEY_COMMENTS];
    if (commentDicts.count > 0) {
        NSMutableArray *commentResult = [[NSMutableArray alloc] init];
        for (NSDictionary *commentDict in commentDicts) {
            [commentResult addObject:[commentDict objectForKeyNotNull:KEY_NICK_NAME]];
        }
        feelingRecord.comments = commentResult;
    }
    
    feelingRecord.commentDict = [NSArray arrayWithArray:commentDicts];
    
    return feelingRecord;
}

- (NSDictionary *)toJSONDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *feelingsArray = [[NSMutableArray alloc] init];
    for (Feeling *feeling in _feelings) {
        [feelingsArray addObject:[feeling toJSONDictionary]];
    }
    [dictionary setObject:feelingsArray forKey:KEY_FEELINGS];
    [dictionary setObject:[NSNumber numberWithDouble:_time] forKey:KEY_TIME];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:_activityIndex] forKey:KEY_ACTIVITY_INDEX];
    if (_comment.length > 0) {
        [dictionary setObject:_comment forKey:KEY_COMMENT];
    } else {
        [dictionary setObject:@"" forKey:KEY_COMMENT];
    }
    [dictionary setObject:[NSNumber numberWithDouble:_location.latitude] forKey:KEY_LATITUDE];
    [dictionary setObject:[NSNumber numberWithDouble:_location.longitude] forKey:KEY_LONGITUDE];
    
    if (_isPublic) {
        [dictionary setObject:[NSNumber numberWithBool:_isPublic] forKey:KEY_IS_PUBLIC];
    }
    
    return dictionary;
}

- (NSString *)activityName
{
    return [FeelingRecord activityNameForIndex:_activityIndex];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.location = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

@end
