//
//  SeparatorViewCell.m
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "SeparatorViewCell.h"

@implementation SeparatorViewCell{
    UIView *_backgroundColoringView, *_contentContainerView;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3)];
        _contentContainerView.backgroundColor = [UIColor whiteColor];
        _backgroundColoringView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, _contentContainerView.frame.size.width, 3)];
        _backgroundColoringView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        [self.contentView addSubview:_backgroundColoringView];
    }
    return self;
}

@end
