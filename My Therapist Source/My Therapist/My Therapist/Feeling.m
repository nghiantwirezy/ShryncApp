//
//  FeelingRecord.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/3/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "Feeling.h"

@implementation Feeling

#pragma mark - Feeling Managements

- (id)init{
    self = [super init];
    if (self) {
        _mainFeelingIndex = INDEX_FEELING_FROM_TEXT;
        _iconID = @"";
        _mainFeelingName = @"";
        _mainFeelingSubtitle = @"";
        _feelingStrength = 0;
        _subFeelingNames = [[NSArray alloc]init];
        _selectedSubFeelingNames = [[NSMutableArray alloc] init];
        _selectedSubFeelingIndexes = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSArray *)createAllFeelings
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *feelingDataDefault = [Feeling feelingDataDefaultFromPlist];
    for (int i = 0; i < feelingDataDefault.count - 1; ++i) {
        Feeling *feeling = [[Feeling alloc] init];
        NSDictionary *dictFeeling = [feelingDataDefault objectAtIndex:i];
        feeling.mainFeelingIndex = [[dictFeeling objectForKey:KEY_FEELING_INDEX_DEFAULT] intValue];
        feeling.mainFeelingName = [dictFeeling objectForKey:KEY_FEELING_NAME_DEFAULT];
        feeling.mainFeelingSubtitle = [dictFeeling objectForKey:KEY_FEELING_SUBTITLE_DEFAULT];
        feeling.subFeelingNames = (NSArray *)[dictFeeling objectForKey:KEY_FEELING_SUBFEELINGS_DEFAULT];
        feeling.iconID = [dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT];
        feeling.feelingActiveIcon = [Feeling imageEmotionWithID:[dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT]];
        feeling.feelingInactiveIcon = [Feeling imageEmotionWithID:[dictFeeling objectForKey:KEY_FEELING_INACTIVE_ICON_ID_DEFAULT]];
        feeling.feelingNameActiveColor = [Feeling colorEmotionWithIconID:[dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT]];
        feeling.feelingNameInactiveColor = [Feeling colorEmotionWithIconID:[dictFeeling objectForKey:KEY_FEELING_INACTIVE_ICON_ID_DEFAULT]];
        [result addObject:feeling];
    }
    return result;
}

+ (Feeling *)fromJSONDictionary:(NSDictionary *)dictionary
{
    int mainFeelingIndex = [[dictionary objectForKey:KEY_MAIN_FEELING_INDEX] intValue];
    NSNumber *feelingStrength = [dictionary objectForKey:KEY_FEELING_STRENGTH];
    NSArray  *subFeelingIndexes = [dictionary objectForKey:KEY_SUB_FEELING_INDEXES];
    NSString *iconID = [dictionary objectForKey:KEY_ICON_ID_UPPERCASE];
    NSString *mainFeeling = [dictionary objectForKey:KEY_MAIN_FEELING_STRING];
    NSArray  *subFeeling;
    if ([[dictionary objectForKey:KEY_SUB_FEELING_STRINGS] isKindOfClass:[NSArray class]]) {
        subFeeling = [dictionary objectForKey:KEY_SUB_FEELING_STRINGS];
    }
    Feeling *feelingFromServer = [[Feeling alloc] init];
    feelingFromServer.feelingStrength = feelingStrength.unsignedIntegerValue;
    
    if (mainFeelingIndex != INDEX_FEELING_FROM_TEXT) {
        // Get fixed data
        NSArray *feelingDataDefault = [Feeling feelingDataDefaultFromPlist];
        for (NSDictionary *dictFeeling in feelingDataDefault) {
            if ([[dictFeeling objectForKey:KEY_FEELING_INDEX_DEFAULT] intValue] == mainFeelingIndex) {
                feelingFromServer.mainFeelingIndex = mainFeelingIndex;
                feelingFromServer.mainFeelingName = [dictFeeling objectForKey:KEY_FEELING_NAME_DEFAULT];
                feelingFromServer.mainFeelingSubtitle = [dictFeeling objectForKey:KEY_FEELING_SUBTITLE_DEFAULT];
                feelingFromServer.subFeelingNames = (subFeeling.count > 0)?subFeeling:[NSArray arrayWithArray:[self subFeelingNamesFromIndexesArray:subFeelingIndexes andMainFeelingIndex:[NSString stringWithFormat:@"%d",mainFeelingIndex]]];
                feelingFromServer.selectedSubFeelingNames = [NSMutableArray arrayWithArray:feelingFromServer.subFeelingNames];
                feelingFromServer.iconID = [dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT];
                feelingFromServer.feelingActiveIcon = [Feeling imageEmotionWithID:[dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT]];
                feelingFromServer.feelingInactiveIcon = [Feeling imageEmotionWithID:[dictFeeling objectForKey:KEY_FEELING_INACTIVE_ICON_ID_DEFAULT]];
                feelingFromServer.feelingNameActiveColor = [Feeling colorEmotionWithIconID:[dictFeeling objectForKey:KEY_FEELING_ACTIVE_ICON_ID_DEFAULT]];
                feelingFromServer.feelingNameInactiveColor = [Feeling colorEmotionWithIconID:[dictFeeling objectForKey:KEY_FEELING_INACTIVE_ICON_ID_DEFAULT]];
                break;
            }
        }
    }else{
        // Get from new data
        feelingFromServer.iconID = iconID;
        feelingFromServer.mainFeelingName = mainFeeling;
        feelingFromServer.subFeelingNames = subFeeling;
        feelingFromServer.selectedSubFeelingNames = [NSMutableArray arrayWithArray:feelingFromServer.subFeelingNames];
        feelingFromServer.feelingActiveIcon   = [Feeling imageEmotionWithID:iconID];
        feelingFromServer.feelingInactiveIcon = [Feeling imageEmotionWithID:iconID];
        feelingFromServer.feelingNameActiveColor = [Feeling colorEmotionWithIconID:iconID];
        feelingFromServer.feelingNameInactiveColor = [Feeling colorEmotionWithIconID:iconID];
    }
    return feelingFromServer;
}

- (NSDictionary *)toJSONDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithUnsignedInteger:_feelingStrength] forKey:KEY_FEELING_STRENGTH];
    [dictionary setValue:_iconID forKey:KEY_ICON_ID_UPPERCASE];
    [dictionary setValue:_mainFeelingName forKey:KEY_MAIN_FEELING_STRING];
    if (_mainFeelingIndex != INDEX_FEELING_FROM_TEXT) {
        NSArray *subFeelingNamesMutableArray = [Feeling subFeelingNamesFromIndexesArray:_selectedSubFeelingIndexes andMainFeelingIndex:[NSString stringWithFormat:@"%d",(int)_mainFeelingIndex]];
        NSString *subFeelingNamesToString = [[NSArray arrayWithArray:subFeelingNamesMutableArray] componentsJoinedByString:@","];
        [dictionary setValue:subFeelingNamesToString forKey:KEY_SUB_FEELING_STRINGS];
    }else{
        NSString *subFeelingNamesToString = (_subFeelingNames.count > 0)?[_subFeelingNames componentsJoinedByString:@","]:@"";
        [dictionary setValue:subFeelingNamesToString forKey:KEY_SUB_FEELING_STRINGS];
    }
    [dictionary setValue:[NSString stringWithFormat:@"%d",_mainFeelingIndex] forKey:KEY_MAIN_FEELING_INDEX];
    return dictionary;
}

- (void)reset
{
    _feelingStrength = 0;
    [_selectedSubFeelingNames removeAllObjects];
    [_selectedSubFeelingIndexes removeAllObjects];
}

#pragma mark - Custom Methods

+ (NSArray *)feelingDataDefaultFromPlist{
    static NSArray *emotionDataArray;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        emotionDataArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:URL_EMOTIONS_DEFAULT_PLIST ofType:@"plist"]];
    });
    return emotionDataArray;
}

+ (NSMutableArray *)subFeelingNamesFromIndexesArray:(NSArray *)indexesArray andMainFeelingIndex:(NSString *)mainFeelingIndex{
    NSMutableArray *subFeelingNamesMutableArray = [[NSMutableArray alloc]init];
    NSArray *feelingDataDefault = [Feeling feelingDataDefaultFromPlist];
    for (NSDictionary *dictFeeling in feelingDataDefault) {
        if ([[dictFeeling objectForKey:KEY_FEELING_INDEX_DEFAULT] isEqualToString:mainFeelingIndex]) {
            NSArray *allSubFeelings = (NSArray *)[dictFeeling objectForKey:KEY_FEELING_SUBFEELINGS_DEFAULT];
            for (int i = 0; i < indexesArray.count; i++) {
                int currentIndex = [[indexesArray objectAtIndex:i] intValue];
                if (currentIndex <= allSubFeelings.count) {
                    [subFeelingNamesMutableArray addObject:[allSubFeelings objectAtIndex:currentIndex]];
                }
            }
        }
    }
    return subFeelingNamesMutableArray;
}

+ (UIImage *)imageEmotionWithID:(NSString *)imageID{
    NSArray *emotionArray = [Feeling loadEmotionDataFromPlist];
    UIImage *imageResult = nil;
    if (emotionArray.count > 0) {
        for (NSDictionary *emotionDict in emotionArray) {
            if ([[emotionDict objectForKey:KEY_EMOTION_ICON_ID] isEqualToString:imageID]) {
                imageResult = [UIImage imageNamed:[emotionDict objectForKey:KEY_EMOTION_ICON_URL]];
                break;
            }
        }
    }
    return imageResult;
}

+ (UIColor *)colorEmotionWithIconID:(NSString *)iconID{
    UIColor *resultColor = [UIColor blackColor];
    NSArray *emotionArray = [Feeling loadEmotionDataFromPlist];
    for (NSDictionary *dict in emotionArray) {
        if ([[dict objectForKey:KEY_EMOTION_ICON_ID] isEqualToString:iconID]) {
            NSDictionary *colorDict = [dict objectForKey:KEY_EMOTION_ICON_COLOR];
            CGFloat redColor    = [[colorDict objectForKey:KEY_EMOTION_ICON_COLOR_RED] floatValue] / 255;
            CGFloat blueColor   = [[colorDict objectForKey:KEY_EMOTION_ICON_COLOR_BLUE] floatValue] / 255;
            CGFloat greenColor  = [[colorDict objectForKey:KEY_EMOTION_ICON_COLOR_GREEN] floatValue] / 255;
            CGFloat alphaColor  = [[colorDict objectForKey:KEY_EMOTION_ICON_COLOR_ALPHA] floatValue];
            resultColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alphaColor];
        }
    }
    return resultColor;
}

+ (NSArray *)loadEmotionDataFromPlist{
    static NSArray *emotionDataArray;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        emotionDataArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:URL_EMOTIONS_IMAGE_PLIST ofType:@"plist"]];
    });
    return emotionDataArray;
}

+ (UIColor *)feelingNameInactiveColor
{
    static UIColor *resultColor;
    static dispatch_once_t dispathOne;
    dispatch_once(&dispathOne, ^{
        resultColor = [UIColor colorWithRed:186.0 / 255 green:186.0 / 255 blue:186.0 / 255 alpha:1.0];
    });
    return resultColor;
}

@end
