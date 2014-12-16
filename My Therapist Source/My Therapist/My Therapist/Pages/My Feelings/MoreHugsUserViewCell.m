//
//  MoreHugsUserViewCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "MoreHugsUserViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserSession.h"
#import "FeelingRecord.h"

#define CornerRadius 12.5
#define CornerRadiusButton 10
#define FONT_LEAGUEGOTHIC_REGULAR @"LeagueGothic-Regular"
#define FONT_BABAS_NEUE @"BebasNeue"
#define SizeFontBig 14
#define SizeFontMid 12
#define SizeFontSmall 11

#define FOLLOW_ENDPOINT @"https://secure.shrync.com/api/user/follow"
#define TOKEN_PARAM @"token"
#define USER_ID_PARAM @"userid"

@implementation MoreHugsUserViewCell{
    FeelingRecord *_feelingRecord;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _usernameLabel.font = [UIFont fontWithName:FONT_LEAGUEGOTHIC_REGULAR size:SizeFontBig];
        [_userImageView.layer setMasksToBounds:YES];
        [_userImageView.layer setCornerRadius:CornerRadius];
        [_followButton.layer setMasksToBounds:YES];
        [_followButton.layer setCornerRadius:CornerRadiusButton];
        
        [_followButton addTarget:self action:@selector(followPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)followPressed:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonActionFollow:)]) {
        [_delegate performSelector:@selector(clickedButtonActionFollow:) withObject:btn];
    }
}
@end
