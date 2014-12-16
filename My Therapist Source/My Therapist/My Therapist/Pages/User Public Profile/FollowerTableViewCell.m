//
//  FollowerTableViewCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "FollowerTableViewCell.h"

#define CornerRadius 12.5
#define CornerRadiusButton 10
#define FONT_LEAGUEGOTHIC_REGULAR @"LeagueGothic-Regular"
#define FONT_BABAS_NEUE @"BebasNeue"
#define SizeFontBig 14
#define SizeFontMid 12
#define SizeFontSmall 11

@implementation FollowerTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _labelUserFollower.font = [UIFont fontWithName:FONT_LEAGUEGOTHIC_REGULAR size:SizeFontBig];
        [_imageUserFollower.layer setMasksToBounds:YES];
        [_imageUserFollower.layer setCornerRadius:CornerRadius];
        [_followerUserButton.layer setMasksToBounds:YES];
        [_followerUserButton.layer setCornerRadius:CornerRadiusButton];
        
        [_followerUserButton addTarget:self action:@selector(followerPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)followerPressed:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonActionFollower:)]) {
        [_delegate performSelector:@selector(clickedButtonActionFollower:) withObject:btn];
    }
}

@end
