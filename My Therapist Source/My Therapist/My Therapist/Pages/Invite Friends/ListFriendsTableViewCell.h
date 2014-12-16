//
//  ListFriendsTableViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListFriendsTableViewCell;

@protocol ListFriendsTableViewCellDelegate <NSObject>
@optional
- (void)clickedButtonActionFollow:(UIButton *)btnFollow;
- (void)clickedButtonFollow:(ListFriendsTableViewCell *)listFriendsTableViewCell buttonFollow:(UIButton *)btnFollow;
@end

@interface ListFriendsTableViewCell : UITableViewCell

@property (nonatomic,assign) id<ListFriendsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserFriends;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonFollow;
@property (strong, nonatomic) NSString *cellIdentifierForTableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
