//
//  ImageAttachmentCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeelingRecord;

@protocol ImageDelegate <NSObject>

- (void)clickedButtonImage:(NSIndexPath *)indexPath;

@end

@interface ImageAttachmentCell : UITableViewCell

@property (nonatomic,retain) id<ImageDelegate> delegate;
@property (nonatomic, retain) UIButton *btnImage;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setFeelingRecord:(FeelingRecord *)record;

+ (CGFloat)cellHeight;
@end
