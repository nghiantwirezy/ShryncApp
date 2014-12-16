//
//  AudioTrackCell.m
//  My Therapist
//
//  Created by Yexiong Feng on 7/31/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "AudioTrackCell.h"
#import "AudioTrack.h"
#import "Feeling.h"
#import "MarqueeLabel.h"

#define FEELING_COLUMN_WIDTH 70
#define TITLE_COLUMN_WIDTH 100
#define DESC_COLUMN_WIDTH 150

@implementation AudioTrackCell {
  UIView *_contentContainerView, *_iconContainerView, *_titleContainerView, *_descriptionContainerView, *_separatorView;
  UIImageView *_iconView;
  MarqueeLabel *_titleLabel, *_descriptionLabel;
  
  AudioTrack *_track;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 16, 16)];
    _iconContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FEELING_COLUMN_WIDTH, 31)];
    [_iconContainerView addSubview:_iconView];
    
    _titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(5, 8, TITLE_COLUMN_WIDTH - 10, 16) rate:20 andFadeLength:5];
    _titleLabel.marqueeType = MLContinuous;
    _titleLabel.animationDelay = 0.7;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
    _titleLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    _titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(FEELING_COLUMN_WIDTH, 0, TITLE_COLUMN_WIDTH, 31)];
    [_titleContainerView addSubview:_titleLabel];
    
    _descriptionLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(5, 8, DESC_COLUMN_WIDTH - 10, 16) rate:20 andFadeLength:5];
    _descriptionLabel.marqueeType = MLContinuous;
    _descriptionLabel.animationDelay = 0.7;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
    _descriptionLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    _descriptionContainerView = [[UIView alloc] initWithFrame:CGRectMake(FEELING_COLUMN_WIDTH + TITLE_COLUMN_WIDTH, 0, DESC_COLUMN_WIDTH, 31)];
    [_descriptionContainerView addSubview:_descriptionLabel];
    
    _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, 320, 1)];
    _separatorView.backgroundColor = [UIColor colorWithRed:202.0 / 255 green:202.0 / 255 blue:202.0 / 255 alpha:1];
    
    _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    [_contentContainerView addSubview:_iconContainerView];
    [_contentContainerView addSubview:_titleContainerView];
    [_contentContainerView addSubview:_descriptionContainerView];
    [_contentContainerView addSubview:_separatorView];
    [self.contentView addSubview:_contentContainerView];
  }
  return self;
}

- (void)awakeFromNib
{
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setTrack:(AudioTrack *)track
{
  _track = track;
  
  _iconView.image = track.feeling.feelingActiveIcon;
  _titleLabel.text = track.title;
  _descriptionLabel.text = track.trackDesc;
}

@end
