//
//  CommentObject.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "CommentObject.h"
#import "Feeling.h"
#import "NSString+JSON.h"
#import "UserSession.h"
#import "NSDictionary+GetNull.h"
#import "NSDate+Helpers.h"

#define FEELINGS_KEY @"feelings"
#define DATA_KEY @"data"
#define NICKNAME_KEY @"nickname"
#define POSTED_TIME_KEY @"posted_time"
#define USERID_KEY @"userid"
#define FEELING_KEY @"feeling"
#define COMMENTS_KEY @"comments"

@implementation CommentObject


+ (NSMutableArray *)commentObjectsWith:(NSDictionary *)dictionary{
    NSMutableArray * _arrayObjComments = [[NSMutableArray alloc]init];
    NSArray *commentObjectDicts = [[dictionary objectForKey:FEELING_KEY] objectForKey:COMMENTS_KEY];
    if ([commentObjectDicts isEqual:[NSNull null]]) {
        return [NSMutableArray new];
    }
    else{
        for (NSDictionary *dicComments in commentObjectDicts) {
            CommentObject *commentObject = [[CommentObject alloc] init];
            
            NSArray *feelingDicts = [[dictionary objectForKey:FEELING_KEY] objectForKey:COMMENTS_KEY];
            NSMutableArray *feelings = [[NSMutableArray alloc] initWithCapacity:feelingDicts.count];
            commentObject.dataArray = feelings;
            
            commentObject.data = [dicComments objectForKey:DATA_KEY];
            
            commentObject.nickname = [dicComments objectForKey:NICKNAME_KEY];
            
            NSTimeInterval time = [[dicComments objectForKey:POSTED_TIME_KEY] doubleValue];
            commentObject.posted_time = time;
            
            commentObject.userid = [dicComments objectForKey:USERID_KEY];
            if (commentObject.data != (id)[NSNull null] && (commentObject.data.length > 0)) {
                [_arrayObjComments addObject:commentObject];
            }
        }
        return _arrayObjComments;
    }
}
@end
