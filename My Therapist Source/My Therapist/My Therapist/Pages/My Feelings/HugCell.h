//
//  HugCell.h
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@class FeelingRecord,CommentObject;

@protocol HugDelegate <NSObject>
@optional
- (void)clickedButtonActionComment:(NSNumber *)indexPath;
- (void)didUpdateNumberHuggerSuccessful:(NSNumber *)section;
- (void)didUpdateNumberHuggerFail;
- (void)didUpdateNumberLikerSuccessful:(NSNumber *)section;
- (void)didUpdateNumberLikerFail;

- (void)didTouchCountHuggerButton:(NSIndexPath *)indexPath;
- (void)didTouchCountLikerButton:(NSIndexPath *)indexPath;

// Return YES to allow change hug/like
- (BOOL)willTouchHugButton:(NSNumber *)section;
- (BOOL)willTouchLikeButton:(NSNumber *)section;

@end

@interface HugCell : UITableViewCell {
    BaseModel *_baseModel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setHugFeelingRecord:(FeelingRecord *)record;
- (void)setLikeFeelingRecord:(FeelingRecord *)record;
- (void)setComments:(CommentObject *)record;

+ (CGFloat)cellHeight;

@property BOOL huggedByMe;
@property BOOL likedByMe;

@property (nonatomic,assign) id<HugDelegate> delegate;
@property (retain, nonatomic) UILabel *totalCommentLabel;
@property (retain, nonatomic) UILabel *commentTextLabel;

@property (retain, nonatomic) UILabel *huggedByLabel;
@property (retain, nonatomic) UILabel *likedByLabel;

@property (retain, nonatomic) UIButton *huggedCountButton;
@property (retain, nonatomic) UIButton *likedCountButton;

@property (retain, nonatomic) UILabel *hugTextLabel;
@property (retain, nonatomic) UILabel *likeTextLabel;

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, retain) UIButton *hugButtonClick;
@property (nonatomic, retain) UIButton *likeButtonClick;
@property (nonatomic, retain) UIButton *commentButtonClick;
@property (nonatomic, retain) UIButton *commentButton;

@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIButton *hugButton;

@end
