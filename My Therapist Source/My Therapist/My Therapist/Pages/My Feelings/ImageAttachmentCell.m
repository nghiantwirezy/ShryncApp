//
//  ImageAttachmentCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "ImageAttachmentCell.h"
#import "FeelingRecord.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserSession.h"
#import "PublicFeelingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MyTherapyViewController.h"
#import "UserInfoCell.h"
#import "PublicFeelingRecordLoader.h"
#import "NSDictionary+GetNull.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+HeightForFontAndWidth.h"
#import "FeelingTextCell.h"
#import "HugCell.h"
#import "ODRefreshControl.h"
#import "ImageAttachmentCell.h"
#import "UserSession.h"
#import "PublicProfileViewController.h"
#import "Feeling.h"

#define WIDTH 290
#define HEIGHT 50
#define TOP_GAP 6
#define BOTTOM_GAP 4

#define THUMBNAIL_URL @"https://secure.shrync.com/api/feelings/thumb"
#define TOKEN_PARAM_KEY @"token"
#define CODE_PARAM_KEY @"feeling"

static NSCache *_thumbnailCache;

@implementation ImageAttachmentCell {
  UIView *_containerView;
  UIImageView *_imageView;
  FeelingRecord *_feelingRecord;
}

+ (void)initialize
{
  _thumbnailCache = [[NSCache alloc] init];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - WIDTH) / 2.0, TOP_GAP, WIDTH, HEIGHT)];
    _containerView.layer.cornerRadius = 5;
    _containerView.layer.masksToBounds = YES;
    _containerView.backgroundColor = [UIColor colorWithRed:80.0 / 255 green:144.0 / 255 blue:155.0 / 255 alpha:1];
    [_containerView addSubview:_imageView];
    
      _btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
      [_btnImage setFrame:_containerView.frame];
      [_btnImage addTarget:self action:@selector(clickButtonI:) forControlEvents:UIControlEventTouchUpInside];
      [_containerView addSubview:_btnImage];
      
    [self.contentView addSubview:_containerView];
  }
  return self;
}

- (void)clickButtonI :(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:btn.tag];
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonImage:)]) {
        [_delegate performSelector:@selector(clickedButtonImage:) withObject:indexPath];
    }
}

- (void)setFeelingRecord:(FeelingRecord *)record
{
  _feelingRecord = record;
  
  _imageView.alpha = 0;
  
  UIImage *thumbnail = [_thumbnailCache objectForKey:record.code];
  if (!thumbnail) {
    NSDictionary *parameters = @{TOKEN_PARAM_KEY: [UserSession currentSession].sessionToken, CODE_PARAM_KEY: _feelingRecord.code};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [manager GET:THUMBNAIL_URL parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [_thumbnailCache setObject:responseObject forKey:record.code];
           [self setImage:responseObject forUserId:record.userId];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
         }];
  } else {
    [self setImage:thumbnail forUserId:record.userId];
  }
}

- (void)setImage:(UIImage *)image forUserId:(NSString *)userId
{
  if ([_feelingRecord.userId caseInsensitiveCompare:userId] == NSOrderedSame) {
    _imageView.image = image;
    
    [UIView animateWithDuration:0.2 animations:^() {
      _imageView.alpha = 1;
    }];
  }
}

+ (CGFloat)cellHeight
{
  return HEIGHT + TOP_GAP + BOTTOM_GAP;
}

@end
