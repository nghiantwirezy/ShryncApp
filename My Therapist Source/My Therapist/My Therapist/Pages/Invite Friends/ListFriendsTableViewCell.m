//
//  ListFriendsTableViewCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "ListFriendsTableViewCell.h"

@implementation ListFriendsTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _labelUsername.font = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL);
        [_imageUserFriends.layer setMasksToBounds:YES];
        [_imageUserFriends.layer setCornerRadius:RADIUS_CORNER_IMAGE_USER_FRIENDS_LIST_FRIENDS_TABLE_VIEW_CELL];
        [_buttonFollow.layer setMasksToBounds:YES];
        [_buttonFollow.layer setCornerRadius:RADIUS_CORNER_BUTTON_FOLLOW_LIST_FRIENDS_TABLE_VIEW_CELL];
        
        [_buttonFollow addTarget:self action:@selector(followPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)followPressed:(UIButton *)button{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonFollow:buttonFollow:)]) {
        [_delegate performSelector:@selector(clickedButtonFollow:buttonFollow:) withObject:self withObject:button];
    }
    
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonActionFollow:)]) {
        [_delegate performSelector:@selector(clickedButtonActionFollow:) withObject:button];
    }
}

@end
