//
//  MoreHugsUserViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreHugsUserViewCellDelegate <NSObject>

- (void)clickedButtonActionFollow:(UIButton *)btnFollow;

@end

@interface MoreHugsUserViewCell : UITableViewCell

@property (nonatomic,assign) id<MoreHugsUserViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentViewMessageCell;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UIButton *followButton;

@end
