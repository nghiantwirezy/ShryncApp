//
//  FeelingFeedSummaryCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FeelingSummaryCell.h"

@class FeelingRecord;

@protocol UserInforDelegate <NSObject>
@optional
- (void)clickedAvatarAtIndexPath:(NSNumber *)indexPath;

@end

@interface UserInfoCell : UITableViewCell

@property (nonatomic,retain) id<UserInforDelegate> delegate;
@property (nonatomic, retain) UIButton *btnClick;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setFeelingRecord:(FeelingRecord *)feelingRecord;
- (void)setAvatar:(UIImage *)avatar forUserId:(NSString *)userId;

+ (CGFloat)cellHeight;

@end
