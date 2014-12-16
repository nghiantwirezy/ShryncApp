//
//  HugDetailViewCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeelingRecord;
@protocol ViewHugByDelegate <NSObject>
- (void)didTouchUserButton :(id)sender;
- (void)didTouchMoreHugUserButton :(id)sender;
@end

@interface HugDetailViewCell : UITableViewCell{
    BOOL checkAnd;
}

@property (nonatomic,retain) id<ViewHugByDelegate> delegate;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setHugDetailCellFeelingRecord:(FeelingRecord *)record;

+ (CGFloat)cellHeight;
- (void)initBase;
@property (nonatomic, strong) NSArray *arrayHugs;
@property (nonatomic, strong) UIFont *fontUsers;

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *huggedByLabel;
@property (strong, nonatomic) UIButton *huggedByButton;
@property (strong, nonatomic) UIButton *huggedBySubButton;
@property (strong, nonatomic) UIView *showSubButton;

@end
