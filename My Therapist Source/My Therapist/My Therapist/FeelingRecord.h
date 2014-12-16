//
//  FeelingRecord.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/13/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FeelingRecord : NSObject

@property (strong, nonatomic) NSArray *feelings;
@property (assign, nonatomic) NSTimeInterval time;
@property (assign, nonatomic) NSUInteger activityIndex;
@property (readonly, nonatomic) NSString *activityName;
@property (strong, nonatomic) NSString *comment;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) UIImage *attachedPicture;

@property (strong, nonatomic) NSString *thumbnailPath;
@property (strong, nonatomic) NSString *code;

@property (strong, nonatomic) NSString *city, *state;
@property (strong, nonatomic) NSString *username;

//Edit 8-10
@property (strong, nonatomic) NSArray *comments;

@property (strong, nonatomic) NSArray *huggers;
@property (strong, nonatomic) NSArray *likers;

@property (strong, nonatomic) NSArray *huggerDict;
@property (strong, nonatomic) NSArray *likerDict;
@property (strong, nonatomic) NSArray *commentDict;

@property (assign, nonatomic) BOOL huggedByMe;
@property (assign, nonatomic) BOOL likedByMe;
@property (assign, nonatomic) BOOL isPublic;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *recordId;

+ (NSArray *)activityNames;
+ (NSString *)activityNameForIndex:(NSUInteger)index;
- (NSDictionary *)toJSONDictionary;
+ (FeelingRecord *)fromDictionary:(NSDictionary *)dictionary;

@end
