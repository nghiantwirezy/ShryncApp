//
//  FeelingTextView.h
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextCommentDelegate <NSObject>

- (void)clickedButtonComment:(NSNumber *)indexPath;

@end

@interface FeelingTextCell : UITableViewCell

@property (nonatomic,retain) id<TextCommentDelegate> delegate;
@property (nonatomic, retain) UIButton *btnComment;

@property (readonly, nonatomic) UITextView *textView;
@property (readonly, nonatomic) UIView *containerView;

@end
