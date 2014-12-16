//
//  FeelingRecord.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/3/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feeling : NSObject

@property (assign, nonatomic) int mainFeelingIndex;
@property (strong, nonatomic) NSString *mainFeelingName;
@property (strong, nonatomic) NSString *mainFeelingSubtitle;
@property (assign, nonatomic) NSUInteger feelingStrength;
@property (strong, nonatomic) NSArray *subFeelingNames;
@property (strong, nonatomic) NSString *iconID;

@property (strong, nonatomic) UIImage *feelingActiveIcon, *feelingInactiveIcon;
@property (strong, nonatomic) UIColor *feelingNameActiveColor, *feelingNameInactiveColor;
@property (strong, nonatomic) NSMutableArray *selectedSubFeelingNames;
@property (strong, nonatomic) NSMutableArray *selectedSubFeelingIndexes;

//+ (NSUInteger)totalFeelingCount;
+ (UIColor *)feelingNameInactiveColor;
+ (NSArray *)createAllFeelings;
+ (Feeling *)fromJSONDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toJSONDictionary;
- (void)reset;
+ (UIImage *)imageEmotionWithID:(NSString *)imageID;
+ (NSArray *)loadEmotionDataFromPlist;
+ (NSArray *)subFeelingNamesFromIndexesArray:(NSArray *)indexesArray andMainFeelingIndex:(NSString *)mainFeelingIndex;
+ (UIColor *)colorEmotionWithIconID:(NSString *)iconID;

@end
