//
//  HugCell.m
//  Copyright (c) 2014 Shrync. All rights reserved.
//

#import "HugCell.h"
#import "NSString+HeightForFontAndWidth.h"
#import "UserSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "FeelingRecord.h"
#import "FeelingRecordLoader.h"
#import "CommentObject.h"
#import "MyFeelingsViewController.h"
#import "PublicFeelingsViewController.h"
#import "UIColor+ColorUtilities.h"

@implementation HugCell {
    UIView *_backgroundColoringView, *_contentContainerView;
    UIButton *_hugButtonClick;
    UIFont *_huggerLabelFont;
    
    FeelingRecord *_feelingRecord;
    CommentObject *_commentObj;
}
#pragma mark - COMMENT Pressed
-(void)commentPressed:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonActionComment:)]) {
        [_delegate performSelector:@selector(clickedButtonActionComment:) withObject:[NSNumber numberWithInt:(int)btn.tag]];
    }
}

#pragma mark - setCommentFeelingRecord
- (void)setComments:(CommentObject *)record{
}

#pragma mark - HUG Pressed
- (void)hugPressed:(UIButton* )sender
{
    BOOL allowTouchHug = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(willTouchHugButton:)]) {
        [_delegate performSelector:@selector(willTouchHugButton:) withObject:[NSNumber numberWithInt:(int)sender.tag]];
        allowTouchHug = [_delegate willTouchHugButton:[NSNumber numberWithInt:(int)sender.tag]];
    }
    
    if (allowTouchHug) {
        if ([_huggedByLabel.text integerValue] < MIN_HUG_TO_SHOW_HUG_CELL) {
            _huggedByLabel.text = @"";
        }else if ([_huggedByLabel.text integerValue] > MAX_HUG_TO_SHOW_HUG_CELL) {
            _huggedByLabel.text = [NSString stringWithFormat:@"%d+",MAX_HUG_TO_SHOW_HUG_CELL];
        }
        
        if (_delegate &&[_delegate respondsToSelector:@selector(didUpdateNumberHuggerSuccessful:)]) {
            [_delegate performSelector:@selector(didUpdateNumberHuggerSuccessful:) withObject:[NSNumber numberWithInt:(int)sender.tag]];
        }
        NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                     KEY_FEELING_ID: [NSNumber numberWithInteger:[_feelingRecord.recordId integerValue]],
                                     KEY_TYPE: [NSNumber numberWithInteger:TYPE_KEY_HUG_HUG_CELL]};
        [_baseModel postFeelingHugEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
            }else {
                if (_delegate &&[_delegate respondsToSelector:@selector(didUpdateNumberHuggerFail)]) {
                    [_delegate performSelector:@selector(didUpdateNumberHuggerFail) withObject:nil];
                }
            }
        }];
    }
}

#pragma mark - setHugFeelingRecord
- (void)setHugFeelingRecord:(FeelingRecord *)record
{
    _feelingRecord = record;
    if (record.huggers.count == 0) {
        _huggedByLabel.text = @"";
        [_hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64] forState:UIControlStateNormal];
        _hugTextLabel.textColor = [UIColor grayColor];
        _huggedByLabel.textColor = [UIColor grayColor];
    } else {
        _huggedByLabel.text = [NSString stringWithFormat:@" %d ",(int)record.huggerDict.count];
        [_hugButton setImage:[UIImage imageNamed:IMAGE_NAME_HEART_64_SELECTED] forState:UIControlStateNormal];
        _hugTextLabel.textColor = [UIColor darkModerateCyanColor];
        _huggedByLabel.textColor = [UIColor darkModerateCyanColor];
        _huggedByMe = NO;
        for (NSDictionary *dicHugger in record.huggerDict) {
            if ([[UserSession currentSession].userId isEqualToString:[dicHugger valueForKey:KEY_USER_ID]]) {
                _huggedByMe = YES;
                break;
            }
        }
        _huggedByLabel.hidden = NO;
    }
}

#pragma mark - LIKE Pressed
-(void)likePressed:(UIButton *)sender {
    BOOL allowTouchLike = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(willTouchLikeButton:)]) {
        [_delegate performSelector:@selector(willTouchLikeButton:) withObject:[NSNumber numberWithInt:(int)sender.tag]];
        allowTouchLike = [_delegate willTouchHugButton:[NSNumber numberWithInt:(int)sender.tag]];
    }
    
    if (allowTouchLike) {
        if ([_likedByLabel.text integerValue] < MIN_LIKE_TO_SHOW_HUG_CELL) {
            _likedByLabel.text = @"";
        }else if ([_likedByLabel.text integerValue] > MAX_HUG_TO_SHOW_HUG_CELL) {
            _likedByLabel.text = [NSString stringWithFormat:@"%d+",MAX_HUG_TO_SHOW_HUG_CELL];
        }
        
        if (_delegate &&[_delegate respondsToSelector:@selector(didUpdateNumberLikerSuccessful:)]) {
            [_delegate performSelector:@selector(didUpdateNumberLikerSuccessful:) withObject:[NSNumber numberWithInt:(int)sender.tag]];
        }
        NSDictionary *parameters = @{KEY_TOKEN_PARAM: [UserSession currentSession].sessionToken,
                                     KEY_FEELING_ID: [NSNumber numberWithInteger:[ _feelingRecord.recordId integerValue]],
                                     KEY_TYPE: [NSNumber numberWithInteger:TYPE_KEY_LIKE_HUG_CELL]};
        [_baseModel postFeelingHugEndPointWithParameters:parameters completion:^(id responseObject, NSError *error){
            if (!error) {
            }else {
                if (_delegate &&[_delegate respondsToSelector:@selector(didUpdateNumberLikerFail)]) {
                    [_delegate performSelector:@selector(didUpdateNumberLikerFail) withObject:nil];
                }
            }
        }];
    }
}

#pragma mark - setLikeFeelingRecord
- (void)setLikeFeelingRecord:(FeelingRecord *)record{
    _feelingRecord = record;
    if (record.likers.count == 0) {
        _likedByLabel.text = @"";
        [_likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP] forState:UIControlStateNormal];
        _likeTextLabel.textColor = [UIColor grayColor];
        _likedByLabel.textColor = [UIColor grayColor];
    } else {
        _likedByLabel.text = [NSString stringWithFormat:@" %d ",(int)record.likerDict.count];
        [_likeButton setImage:[UIImage imageNamed:IMAGE_NAME_THUMB_UP_SELECTED] forState:UIControlStateNormal];
        _likeTextLabel.textColor = [UIColor darkModerateCyanColor];
        _likedByLabel.textColor = [UIColor darkModerateCyanColor];
        _likedByMe = NO;
        for (NSDictionary *dicLikerr in record.likerDict) {
            if ([[UserSession currentSession].userId isEqualToString:[dicLikerr valueForKey:KEY_USER_ID]]) {
                _likedByMe = YES;
                break;
            }
        }
    }
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _huggerLabelFont = COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL);
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEIGHT_CELL_HUG_CELL)];
        _contentContainerView.backgroundColor = [UIColor whiteColor];
        
        //HUG Button
        _hugButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_contentContainerView addSubview:_hugButton];
        
        _hugTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUTTON_LEFT_GAP_HUG_CELL + (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL) + HUG_TEXT_LABEL_LEFT_GAP_HUG_CELL, HUG_TEXT_LABEL_TOP_GAP_HUG_CELL, WIDTH_HUG_TEXT_LABEL_HUG_CELL, HEIGHT_HUG_TEXT_LABEL_HUG_CELL)];
        _hugTextLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
        _hugTextLabel.textColor = [UIColor grayColor];
        _hugTextLabel.text = NSLocalizedString(TEXT_LABEL_HUG_HUG_CELL, nil);
        [_contentContainerView addSubview:_hugTextLabel];
        
        _hugButtonClick = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_HUG_CELL, (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)+ WIDTH_HUG_TEXT_LABEL_HUG_CELL , HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_hugButtonClick setBackgroundColor:[UIColor clearColor]];
        [_hugButtonClick addTarget:self action:@selector(hugPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentContainerView addSubview:_hugButtonClick];
        
        _huggedCountButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_HUGGER_LABEL_APTER_HUG_CELL, HUGGER_LABEL_TOP_GAP_HUG_CELL, WIDTH_HUGGER_LABEL_BY_HUG_CELL, HEIGHT_HUGGER_LABEL_HUG_CELL)];
        [_huggedCountButton addTarget:self action:@selector(didTouchCountHugger:) forControlEvents:UIControlEventTouchUpInside];
        [_huggedCountButton.titleLabel setFont:COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL)];
        [_contentContainerView addSubview:_huggedCountButton];
        
        //LIKE Button
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_LIKE_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_contentContainerView addSubview:_likeButton];
        
        _likeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUTTON_LIKE_LEFT_GAP_HUG_CELL + (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL) + HUG_TEXT_LABEL_LEFT_GAP_HUG_CELL, HUG_TEXT_LABEL_TOP_GAP_HUG_CELL, WIDTH_LIKE_TEXT_LABEL_HUG_CELL, HEIGHT_HUG_TEXT_LABEL_HUG_CELL)];
        _likeTextLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
        _likeTextLabel.textColor = [UIColor grayColor];
        _likeTextLabel.text = NSLocalizedString(TEXT_LABEL_LIKE_HUG_CELL, nil);
        [_contentContainerView addSubview:_likeTextLabel];
        
        _likeButtonClick = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_LIKE_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_HUG_CELL, (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)
                                                                      + WIDTH_LIKE_TEXT_LABEL_HUG_CELL , HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_likeButtonClick setBackgroundColor:[UIColor clearColor]];
        [_likeButtonClick addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentContainerView addSubview:_likeButtonClick];
        
        _likedCountButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_LIKE_LABEL_APTER_HUG_CELL, HUGGER_LABEL_TOP_GAP_HUG_CELL, WIDTH_HUGGER_LABEL_BY_HUG_CELL, HEIGHT_HUGGER_LABEL_HUG_CELL)];
        [_likedCountButton addTarget:self action:@selector(didTouchCountLiker:) forControlEvents:UIControlEventTouchUpInside];
        [_likedCountButton.titleLabel setFont:COMMON_LEAGUE_GOTHIC_FONT(SIZE_FONT_SMALL)];
        [_contentContainerView addSubview:_likedCountButton];
        
        //COMMENT Button
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_COMMENT_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_2_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL, HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_commentButton setImage:[UIImage imageNamed:IMAGE_NAME_COMMENT_32_NORMAL] forState:UIControlStateNormal];
        [_contentContainerView addSubview:_commentButton];
        
        _commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUTTON_COMMENT_LEFT_GAP_HUG_CELL + (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL) + HUG_TEXT_LABEL_LEFT_GAP_HUG_CELL, HUG_TEXT_LABEL_TOP_GAP_HUG_CELL, WIDTH_COMMENT_TEXT_LABEL_HUG_CELL, HEIGHT_HUG_TEXT_LABEL_HUG_CELL)];
        _commentTextLabel.font = COMMON_BEBAS_FONT(SIZE_FONT_SMALL);
        _commentTextLabel.textColor = [UIColor grayColor];
        _commentTextLabel.text = NSLocalizedString(TEXT_LABEL_COMMENT_HUG_CELL, nil);
        [_contentContainerView addSubview:_commentTextLabel];
        
        _commentButtonClick = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_COMMENT_LEFT_GAP_HUG_CELL, BUTTON_TOP_GAP_HUG_CELL, (HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)+ WIDTH_COMMENT_TEXT_LABEL_HUG_CELL , HEIGHT_CELL_HUG_CELL - 2 * BUTTON_TOP_GAP_HUG_CELL)];
        [_commentButtonClick setBackgroundColor:[UIColor clearColor]];
        [_commentButtonClick addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentContainerView addSubview:_commentButtonClick];
        
        _totalCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_COMMENT_LABEL_APTER_HUG_CELL, HUGGER_LABEL_TOP_GAP_HUG_CELL,
                                                                       WIDTH_HUGGER_LABEL_BY_HUG_CELL, HEIGHT_HUGGER_LABEL_HUG_CELL)];
        _totalCommentLabel.font = _huggerLabelFont;
        _totalCommentLabel.textColor = [UIColor veryDarkGrayColor];
        [_contentContainerView addSubview:_totalCommentLabel];
        
        _backgroundColoringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentContainerView.frame.size.width, HEIGHT_CELL_HUG_CELL + 0)];
        _backgroundColoringView.backgroundColor = [UIColor veryLightGrayColor4];
        [_backgroundColoringView addSubview:_contentContainerView];
        [self setComments:_commentObj];
        [self.contentView addSubview:_backgroundColoringView];
        _baseModel = [BaseModel shareBaseModel];
    }
    return self;
}

-(void)didTouchCountHugger:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:btn.tag];
    if (_delegate &&[_delegate respondsToSelector:@selector(didTouchCountHuggerButton:)]) {
        [_delegate performSelector:@selector(didTouchCountHuggerButton:) withObject:indexPath];
    }
}

-(void)didTouchCountLiker:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:btn.tag];
    if (_delegate &&[_delegate respondsToSelector:@selector(didTouchCountLikerButton:)]) {
        [_delegate performSelector:@selector(didTouchCountLikerButton:) withObject:indexPath];
    }
}

+ (CGFloat)cellHeight
{
    return HEIGHT_CELL_HUG_CELL + HEIGHT_SPACE_CELL_HUG_CELL;
}

@end
