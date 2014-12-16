//
//  FeelingFeedSummaryCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "UserInfoCell.h"
#import "CenterCircleImageView.h"
#import "FeelingRecord.h"
#import "UserSession.h"

#define AVATAR_EDGE 45
#define AVATAR_TOP_GAP 4
#define AVATAR_LEFT_GAP 5
#define AVATAR_BOTTOM_GAP 4

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

#define ME @"ME!"

@implementation UserInfoCell {
    UILabel *_usernameLabel, *_locationLabel, *_timeLabel;
    UIImageView *_avatarView;
    UIView *_backgroundColoringView, *_userInfoContainerView, *_userTextContainerView, *_nameAndTimeContainerView, *_separatorView;
    FeelingRecord *_feelingRecord;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userInfoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, AVATAR_BOTTOM_GAP + AVATAR_EDGE + AVATAR_TOP_GAP)];
        
        _avatarView = [[CenterCircleImageView alloc] initWithFrame:CGRectMake(AVATAR_LEFT_GAP, AVATAR_TOP_GAP, AVATAR_EDGE, AVATAR_EDGE)];
        _userInfoContainerView.backgroundColor = _avatarView.backgroundColor = [UIColor whiteColor];
        [_userInfoContainerView addSubview:_avatarView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        _usernameLabel.font = [UIFont fontWithName:@"BebasNeue" size:16.0];
        _usernameLabel.textColor = [UIColor colorWithRed:62.0 / 255 green:62.0 / 255 blue:62.0 / 255 alpha:1];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(136, 1, 120, 14)];
        _timeLabel.font = [UIFont fontWithName:@"BebasNeue" size:14.0];
        _timeLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _nameAndTimeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 256, 16)];
        [_nameAndTimeContainerView addSubview:_usernameLabel];
        [_nameAndTimeContainerView addSubview:_timeLabel];
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 256, 12)];
        _locationLabel.font = [UIFont fontWithName:@"BebasNeue" size:12.0];
        _locationLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        
        _userTextContainerView = [[UIView alloc] initWithFrame:CGRectMake(52, ([UserInfoCell cellHeight] - AVATAR_EDGE) / 2 + 3, 320 - 52, AVATAR_EDGE - 6)];
        [_userTextContainerView addSubview:_nameAndTimeContainerView];
        [_userTextContainerView addSubview:_locationLabel];
        
        [_userInfoContainerView addSubview:_userTextContainerView];
        
        _backgroundColoringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _userInfoContainerView.frame.size.width, _userInfoContainerView.frame.size.height + 5)];
        _backgroundColoringView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        [_backgroundColoringView addSubview:_userInfoContainerView];
        
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundColoringView.frame.size.height - 1, _backgroundColoringView.frame.size.width, 1)];
        _separatorView.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
        [_backgroundColoringView addSubview:_separatorView];
        _btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btnClick setBackgroundColor:[UIColor clearColor]];
        [_btnClick setFrame:_backgroundColoringView.frame];
        [_btnClick addTarget:self action:@selector(clickName:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_backgroundColoringView];
        [self.contentView addSubview:_btnClick];
    }
    return self;
}

-(void)clickName:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedAvatarAtIndexPath:)]) {
        [_delegate performSelector:@selector(clickedAvatarAtIndexPath:) withObject:[NSNumber numberWithInt:btn.tag]];
    }
}

- (void)setFeelingRecord:(FeelingRecord *)feelingRecord
{
    _feelingRecord = feelingRecord;
    
    _avatarView.alpha = 0;
    
    if ([feelingRecord.userId caseInsensitiveCompare:[UserSession currentSession].userId] == NSOrderedSame) {
        _usernameLabel.textColor = [UIColor colorWithRed:186.0 / 255 green:27.0 / 255 blue:21.0 / 255 alpha:1];
        _usernameLabel.text = NSLocalizedString(ME, nil);
    } else {
        _usernameLabel.textColor = [UIColor colorWithRed:62.0 / 255 green:62.0 / 255 blue:62.0 / 255 alpha:1];
        _usernameLabel.text = feelingRecord.username;
    }
    
    NSString *timeString = nil;
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    double delta = now - feelingRecord.time;
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
    _timeLabel.text = timeString;
    
    if (feelingRecord.city.length == 0) {
        _locationLabel.hidden = YES;
        
        CGRect frame = _nameAndTimeContainerView.frame;
        frame.origin.y = (_userTextContainerView.frame.size.height - frame.size.height) / 2;
        _nameAndTimeContainerView.frame = frame;
    } else {
        _locationLabel.hidden = NO;
        _locationLabel.text = [NSString stringWithFormat:@"%@, %@", feelingRecord.city, feelingRecord.state];
        
        CGRect frame = _nameAndTimeContainerView.frame;
        frame.origin.y = 0;
        _nameAndTimeContainerView.frame = frame;
    }
}

- (void)setAvatar:(UIImage *)avatar forUserId:(NSString *)userId
{
    if ([_feelingRecord.userId caseInsensitiveCompare:userId] == NSOrderedSame) {
        _avatarView.image = avatar;
        [UIView animateWithDuration:0.2 animations:^() {
            _avatarView.alpha = 1;
        }];
    }
}

+ (CGFloat)cellHeight
{
    return AVATAR_BOTTOM_GAP + AVATAR_EDGE + AVATAR_TOP_GAP + 5;
}

@end
