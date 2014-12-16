//
//  FollowerTableViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FollowerTableViewCellDelegate <NSObject>

- (void)clickedButtonActionFollower:(UIButton *)btnFollower;

@end

@interface FollowerTableViewCell : UITableViewCell

@property (nonatomic,assign) id<FollowerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentFollowerCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserFollower;
@property (weak, nonatomic) IBOutlet UILabel *labelUserFollower;
@property (weak, nonatomic) IBOutlet UIButton *followerUserButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
