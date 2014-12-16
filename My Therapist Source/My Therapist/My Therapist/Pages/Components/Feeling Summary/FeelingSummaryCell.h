//
//  FeelingSummaryCell.h
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feeling;

@protocol FeelingSummeryDelegate <NSObject>

- (void)clickedButtonStatus:(NSNumber *)indexPath;

@end

@interface FeelingSummaryCell : UITableViewCell {
  UIView *_contentContainerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addContentView:(BOOL)addContentView;
- (void)setFeeling:(Feeling *)feeling;
@property (nonatomic,retain) id<FeelingSummeryDelegate> delegate;
@property (nonatomic, retain) UIButton *btnStatus;

@end
