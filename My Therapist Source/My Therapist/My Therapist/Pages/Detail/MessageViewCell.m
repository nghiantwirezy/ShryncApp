//
//  MessageViewCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "MessageViewCell.h"
#import "DetailCommentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#define CommonBebasFont(fontSize) [UIFont fontWithName : @"BebasNeue" size : fontSize]
#define CommonLeagueGothicFont(fontSize) [UIFont fontWithName : @"LeagueGothic-Regular" size : fontSize]
#define SizeFontBig 15
#define SizeFontMid 12
#define SizeFontSmall 11
#define CornerRadius 12.5
#define CELL_HEIGHT 25.0

@implementation MessageViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _commentTextView.scrollEnabled = NO;
        _commentTextView.editable = NO;
        
        [_imageUserComment.layer setMasksToBounds:YES];
        [_imageUserComment.layer setCornerRadius:CornerRadius];
        
        _btnClickMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClickMessage setFrame:_messageContentView.frame];
        _btnClickMessage.backgroundColor = [UIColor clearColor];
        [_btnClickMessage addTarget:self action:@selector(clickMessageCell:) forControlEvents:UIControlEventTouchUpInside];
        [_messageContentView addSubview:_btnClickMessage];
    }
    return self;
}

- (void)clickMessageCell :(UIButton *)btn{
    NSLog(@"Click message cell");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedMessageViewCell:)]) {
        [_delegate performSelector:@selector(clickedMessageViewCell:) withObject:indexPath];
    }
}

@end
