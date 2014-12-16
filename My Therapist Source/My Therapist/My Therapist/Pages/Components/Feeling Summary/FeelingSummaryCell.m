//
//  FeelingSummaryCell.m
//  My Therapist
//
//  Created by Yexiong Feng on 12/4/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "FeelingSummaryCell.h"
#import "PublicFeelingsViewController.h"
#import "FeelingRecord.h"
#import "UserInfoCell.h"
#import "PublicFeelingRecordLoader.h"
#import "NSDictionary+GetNull.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+HeightForFontAndWidth.h"
#import "FeelingTextCell.h"
#import "HugCell.h"
#import "ODRefreshControl.h"
#import "ImageAttachmentCell.h"
#import "UserSession.h"
#import "PublicProfileViewController.h"
#import "Feeling.h"
#import "AppDelegate.h"
#import "MyTherapyViewController.h"

#define FEELING_FROM_TEXT_INDEX 10

static NSDictionary *_subtitleStringAttributes;

@implementation FeelingSummaryCell {
    UIView *_textContainerView;
    UIImageView *_iconView, *_feelingStrengthView;;
    UILabel *_feelingNameLabel, *_subFeelingStringLabel, *_subFeelingStringOverflowLabel;
}

- (NSMutableString *)stringFromSubFeelingNames:(NSArray *)subFeelingNames
{
    if (subFeelingNames.count == 0) {
        return nil;
    }
    
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i = 0; i < (subFeelingNames.count - 1); ++i) {
        NSString *subFeelingName = [subFeelingNames objectAtIndex:i];
        [string appendString:subFeelingName];
        [string appendString:@", "];
    }
    NSString *subFeelingName = [subFeelingNames lastObject];
    [string appendString:subFeelingName];
    return string;
}

- (NSArray *)stringsFromSubFeelingNames:(NSArray *)subFeelingNames
{
    if (subFeelingNames.count == 0) {
        return nil;
    }
    
    NSMutableString *firstString = [[NSMutableString alloc] init];
    NSMutableString *secondString;
    
    secondString = [self stringFromSubFeelingNames:subFeelingNames];
    CGSize evaluatedSize = [secondString sizeWithAttributes:_subtitleStringAttributes];
    if (evaluatedSize.width >= _subFeelingStringLabel.frame.size.width) {
        NSString *subFeelingName = [subFeelingNames firstObject];
        
        firstString = [[NSMutableString alloc] initWithString:subFeelingName];
        NSMutableString *evaluateString = [[NSMutableString alloc] initWithString:subFeelingName];
        
        for (int i = 1; i < subFeelingNames.count; ++i) {
            subFeelingName = [subFeelingNames objectAtIndex:i];
            [evaluateString appendString:@", "];
            [evaluateString appendString:subFeelingName];
            
            CGSize evaluatedSize = [evaluateString sizeWithAttributes:_subtitleStringAttributes];
            if (evaluatedSize.width < _subFeelingStringOverflowLabel.frame.size.width) {
                [firstString appendString:@", "];
                [firstString appendString:subFeelingName];
            } else {
                NSRange range = NSMakeRange(i, subFeelingNames.count - i);
                secondString = [self stringFromSubFeelingNames:[subFeelingNames subarrayWithRange:range]];
                break;
            }
        }
    }
    
    return [NSArray arrayWithObjects:firstString, secondString, nil];
}

- (void)setFeeling:(Feeling *)feeling
{
    _iconView.image = [Feeling imageEmotionWithID:feeling.iconID];
    _feelingNameLabel.text = feeling.mainFeelingName;
    _feelingNameLabel.textColor = feeling.feelingNameActiveColor;
    
    CGSize nameStringSize = [feeling.mainFeelingName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_feelingNameLabel.font, NSFontAttributeName, nil]];
    
    BOOL needToShowSubFeeling = NO;
    if ((feeling.selectedSubFeelingNames.count > 0) || (feeling.subFeelingNames.count > 0) || (feeling.selectedSubFeelingIndexes.count > 0)) {
        needToShowSubFeeling = YES;
    }
    if (!needToShowSubFeeling) {
        _subFeelingStringOverflowLabel.hidden = _subFeelingStringLabel.hidden = YES;
        
        CGRect frame = _feelingNameLabel.frame;
        CGFloat offsetY = floorf((_textContainerView.frame.size.height - frame.size.height) / 2);
        frame.origin.y = offsetY;
        frame.size.width = nameStringSize.width;
        _feelingNameLabel.frame = frame;
    } else {
        CGRect frame = _feelingNameLabel.frame;
        frame.origin.y = 0;
        frame.size.width = nameStringSize.width;
        _feelingNameLabel.frame = frame;
        
        CGRect overflowLabelFrame = CGRectMake(_feelingNameLabel.frame.size.width + 6, _feelingNameLabel.frame.origin.y + _feelingNameLabel.frame.size.height - _subFeelingStringLabel.frame.size.height - 1, _textContainerView.frame.size.width - (_feelingNameLabel.frame.size.width + 6), _subFeelingStringLabel.frame.size.height);
        _subFeelingStringOverflowLabel.frame = overflowLabelFrame;
        NSArray *subFeelingGroups;
        if (feeling.mainFeelingIndex != FEELING_FROM_TEXT_INDEX && (feeling.selectedSubFeelingIndexes.count > 0)) {
            if (feeling.selectedSubFeelingNames.count > 0) {
                subFeelingGroups = [self stringsFromSubFeelingNames:feeling.selectedSubFeelingNames];
            }else {
                subFeelingGroups = [self stringsFromSubFeelingNames:[Feeling subFeelingNamesFromIndexesArray:feeling.selectedSubFeelingIndexes andMainFeelingIndex:[NSString stringWithFormat:@"%d",(int)feeling.mainFeelingIndex]]];
            }
        }else{
            subFeelingGroups = [self stringsFromSubFeelingNames:feeling.selectedSubFeelingNames];
        }
        _subFeelingStringOverflowLabel.hidden = _subFeelingStringLabel.hidden = NO;
        _subFeelingStringOverflowLabel.text = [subFeelingGroups objectAtIndex:0];
        _subFeelingStringLabel.text = [subFeelingGroups objectAtIndex:1];
    }
    
    _feelingStrengthView.image = [UIImage imageNamed:[NSString stringWithFormat:@"large %lu.png", (unsigned long)feeling.feelingStrength]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addContentView:(BOOL)addContentView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textContainerView = [[UIView alloc] initWithFrame:CGRectMake(52, 8, 216, 26)];
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 32, 32)];
        _feelingStrengthView = [[UIImageView alloc] initWithFrame:CGRectMake(274, 5, 32, 32)];
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
        [_contentContainerView addSubview:_iconView];
        [_contentContainerView addSubview:_textContainerView];
        [_contentContainerView addSubview:_feelingStrengthView];
        
        _feelingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _textContainerView.frame.size.width, 12)];
        _feelingNameLabel.font = [UIFont fontWithName:@"BebasNeue" size:15.0];
        
        _subFeelingStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, _textContainerView.frame.size.width, 9)];
        _subFeelingStringLabel.font = [UIFont fontWithName:@"BebasNeue" size:11];
        _subFeelingStringLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        
        _subFeelingStringOverflowLabel = [[UILabel alloc] init];
        _subFeelingStringOverflowLabel.font = [UIFont fontWithName:@"BebasNeue" size:11];
        _subFeelingStringOverflowLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        
        [_textContainerView addSubview:_feelingNameLabel];
        [_textContainerView addSubview:_subFeelingStringLabel];
        [_textContainerView addSubview:_subFeelingStringOverflowLabel];
        
        _subtitleStringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_subFeelingStringLabel.font, NSFontAttributeName, nil];
        
        _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnStatus setFrame:_contentContainerView.frame];
        [_btnStatus addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentContainerView addSubview:_btnStatus];
        
        if (addContentView) {
            [self.contentView addSubview:_contentContainerView];
        }
    }
    return self;
}

- (void)clickButton :(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonStatus:)]) {
        [_delegate performSelector:@selector(clickedButtonStatus:) withObject:[NSNumber numberWithInt:btn.tag]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier addContentView:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
