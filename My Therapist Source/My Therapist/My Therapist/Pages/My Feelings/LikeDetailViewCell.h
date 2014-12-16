//
//  LikeDetailViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeelingRecord;

@protocol ViewLikeByDelegate <NSObject>
- (void)didTouchLikeUserButton :(id)sender;
- (void)didTouchMoreLikeUserButton :(id)sender;
@end

@interface LikeDetailViewCell : UITableViewCell{
    BOOL checkAndLike;
}

@property (nonatomic,retain) id<ViewLikeByDelegate> delegate;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)cellHeight;
- (void)initBase;

@property (nonatomic, strong) NSArray *arrayLikes;
@property (nonatomic, strong) UIFont *fontUsers;

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *likedByLabel;

@end
