//
//  FollowObject.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FollowObject.h"
#import "Feeling.h"
#import "NSString+JSON.h"
#import "UserSession.h"
#import "NSDictionary+GetNull.h"
#import "NSDate+Helpers.h"

#define USER_ID_KEY @"id"
#define NICK_NAME_KEY @"nickname"
#define TYPE_KEY @"type"
#define RELATIONSHIP_KEY @"relationship"
#define AVATAR @"avatar"
#define LAST_UPDATE_KEY @"lastupdated"

@implementation FollowObject

+ (NSMutableArray *)followObjectsWith:(NSArray *)arrayJson{
    NSMutableArray *feelings = [[NSMutableArray alloc] initWithCapacity:arrayJson.count];
        for (NSDictionary *dicFollows in arrayJson) {
            FollowObject *followObject = [[FollowObject alloc] init];
            
            followObject.user_id = [dicFollows objectForKey:USER_ID_KEY];
            
            followObject.user_type = [dicFollows objectForKey:TYPE_KEY];
            
            NSTimeInterval time = [[dicFollows objectForKey:LAST_UPDATE_KEY] doubleValue];
            followObject.lastupdated = time;
            
            followObject.nickname = [dicFollows objectForKey:NICK_NAME_KEY];
            
            followObject.relationship = [dicFollows objectForKey:RELATIONSHIP_KEY];
            
            [feelings addObject:followObject];
        }
        return feelings;
}

@end
