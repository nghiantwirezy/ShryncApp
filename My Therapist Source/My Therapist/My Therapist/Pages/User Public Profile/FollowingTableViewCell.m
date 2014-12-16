//
//  FollowingTableViewCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FollowingTableViewCell.h"

#define CornerRadius 12.5
#define CornerRadiusButton 10
#define FONT_LEAGUEGOTHIC_REGULAR @"LeagueGothic-Regular"
#define FONT_BABAS_NEUE @"BebasNeue"
#define SizeFontBig 14
#define SizeFontMid 12
#define SizeFontSmall 11

@implementation FollowingTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _labelUserFollowing.font = [UIFont fontWithName:FONT_LEAGUEGOTHIC_REGULAR size:SizeFontBig];
        [_imageUserFollowing.layer setMasksToBounds:YES];
        [_imageUserFollowing.layer setCornerRadius:CornerRadius];
        [_followingCellButton.layer setMasksToBounds:YES];
        [_followingCellButton.layer setCornerRadius:CornerRadiusButton];
        
        [_followingCellButton addTarget:self action:@selector(followingPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)followingPressed:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonActionFollowing:)]) {
        [_delegate performSelector:@selector(clickedButtonActionFollowing:) withObject:btn];
    }
}

@end
