//
//  FeelingTextView.m
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "FeelingTextCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeelingTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textView = [[UITextView alloc] init];
        _textView.scrollEnabled = NO;
        _textView.editable = NO;
        _textView.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:17.0f];
        _textView.textColor = [UIColor colorWithRed:83 / 255.0 green:83 / 255.0 blue:83 / 255.0 alpha:1];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.frame = CGRectMake(5, 0, 280, 0);
        
        _containerView = [[UIView alloc] init];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1];
        [_containerView addSubview:_textView];
        
        _containerView.frame = CGRectMake(15, 5, 290, 0);
        
        _btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnComment setFrame:_containerView.frame];
        _btnComment.backgroundColor = [UIColor clearColor];
        [_btnComment addTarget:self action:@selector(clickButtonC:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_btnComment];
        
        [self.contentView addSubview:_containerView];
    }
    return self;
}

- (void)clickButtonC :(UIButton *)btn{
    NSLog(@"Click comment");
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonComment:)]) {
        [_delegate performSelector:@selector(clickedButtonComment:) withObject:[NSNumber numberWithInt:btn.tag]];
    }
}

@end
