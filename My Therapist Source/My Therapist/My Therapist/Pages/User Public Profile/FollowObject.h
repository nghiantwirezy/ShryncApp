//
//  FollowObject.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowObject : NSObject

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *user_type;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) NSTimeInterval lastupdated;

+ (NSMutableArray *)followObjectsWith:(NSArray *)arrayJson;

@end
