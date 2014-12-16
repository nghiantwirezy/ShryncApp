//
//  CommentObject.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentObject : NSObject

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *userid;
@property (assign, nonatomic) NSTimeInterval posted_time;

+ (NSMutableArray *)commentObjectsWith:(NSDictionary *)dictionary;

@end
