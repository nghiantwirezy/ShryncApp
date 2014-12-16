//
//  FollowingTableViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FollowingTableViewCellDelegate <NSObject>

- (void)clickedButtonActionFollowing:(UIButton *)btnFollowing;

@end

@interface FollowingTableViewCell : UITableViewCell

@property (nonatomic,assign) id<FollowingTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentFollowingCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserFollowing;
@property (weak, nonatomic) IBOutlet UILabel *labelUserFollowing;
@property (weak, nonatomic) IBOutlet UIButton *followingCellButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
