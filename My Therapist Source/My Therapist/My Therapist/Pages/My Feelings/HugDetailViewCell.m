//
//  HugDetailViewCell.m
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "HugDetailViewCell.h"
#import "FeelingRecord.h"
#import "NSString+HeightForFontAndWidth.h"
#import "UserSession.h"
#import "AFHTTPRequestOperationManager.h"

#define HUG_ENDPOINT @"https://secure.shrync.com/api/feelings/hug"
#define TOKEN_PARAM @"token"
#define FEELING_ID_PARAM @"feelingid"
#define TYPE_PARAM @"type"

#define CELL_HEIGHT 25.0
#define BUTTON_LEFT_GAP 12
#define BUTTON_TOP_GAP 5
#define HUG_TEXT_LABEL_LEFT_GAP 4
#define HUG_TEXT_LABEL_TOP_GAP 10
#define HUG_TEXT_LABEL_HEIGHT 16
#define HUG_TEXT_LABEL_WIDTH 20
#define HUGGER_LABEL_RIGHT_GAP 12
#define HUGGER_LABEL_TOP_GAP 5
#define HUGGER_LABEL_HEIGHT 16
#define HUGGER_LABEL_WIDTH 275
#define HUGGER_LABEL_WIDTH2 45
#define HUG_TEXT_BY_LABEL_LEFT_GAP 34

#define SHOULD_REMOVE_LABEL_TAG 99

#define TEST 80

#define HUG_NICKNAME @"nickname"
#define HUG_USERID @"userid"

#define HUGGED_BY @" "
#define AND_MORE @" and %d more."

@implementation HugDetailViewCell{
    UIView *_backgroundColoringView, *_contentContainerView;
    UIButton *_hugButton;
    UILabel *_hugTextLabel;
    FeelingRecord *_feelingRecord;
    UIFont *_huggerLabelFont;
}

- (void)setHugDetailCellFeelingRecord:(FeelingRecord *)record{
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initBase{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    for (UILabel *label in self.subviews) {
        if (label.tag == SHOULD_REMOVE_LABEL_TAG) {
            [label removeFromSuperview];
        }
    }
    
    UILabel *viewLabelHugBy = [[UILabel alloc]initWithFrame:CGRectMake(33, 5, 43, 16)];
    viewLabelHugBy.font = self.fontUsers;
    viewLabelHugBy.text = @"Hugged by:";
    viewLabelHugBy.tag = SHOULD_REMOVE_LABEL_TAG;
    viewLabelHugBy.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    [self addSubview:viewLabelHugBy];
    //init buttons view
    float fTotalCurrentWith = 0.0;
    float fCurrentPointXandLabel = CGRectGetWidth(self.contentView.frame) - 100;
    float fCurrentX = CGRectGetMaxX(viewLabelHugBy.frame)+2;
    float fCuttentY = 5.0;
    float fCuttentHeight = 16.0;
    int i=0;
    int maxTag = 0;
    for (NSDictionary *dicHug in self.arrayHugs) {
        NSString *str= [dicHug valueForKey:HUG_NICKNAME];
        float fCurentWidth = [self widthOfString:str withFont:self.fontUsers]+5;
        fTotalCurrentWith +=fCurentWidth;
        if (fCurrentX <fCurrentPointXandLabel) {
            UIButton *btnHugUser = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnHugUser setTitle:[NSString stringWithFormat:@"%@,",str] forState:UIControlStateNormal];
            [btnHugUser setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btnHugUser.titleLabel setFont:self.fontUsers];
            [btnHugUser setTag:[[dicHug valueForKey:HUG_USERID] integerValue]];
            [btnHugUser addTarget:self action:@selector(didClickUser:) forControlEvents:UIControlEventTouchUpInside];
            btnHugUser.frame = CGRectMake(fCurrentX, fCuttentY, fCurentWidth, fCuttentHeight);
            fCurrentX = CGRectGetMaxX(btnHugUser.frame);
            [self.contentView addSubview:btnHugUser];
            i++;
            maxTag = btnHugUser.tag;
            checkAnd = YES;
        }else{
            checkAnd = NO;
            UIButton *buttonMore = [[UIButton alloc]initWithFrame:CGRectMake(fCurrentX, fCuttentY, CGRectGetWidth(self.contentView.frame)-fCurrentX, fCuttentHeight)];
            [buttonMore.titleLabel setFont:self.fontUsers];
            [buttonMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            if (self.arrayHugs.count - i) {
                [buttonMore setTitle:[NSString stringWithFormat:@"and %ld more",self.arrayHugs.count - i] forState:UIControlStateNormal];
                buttonMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [buttonMore addTarget:self action:@selector(didClickMoreUser:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:buttonMore];
            }
        }
    }
    [self renameButtonWithTag:maxTag];
    [self redrawButtonUser];
    _hugButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_LEFT_GAP, BUTTON_TOP_GAP, CELL_HEIGHT - 2 * BUTTON_TOP_GAP, CELL_HEIGHT - 2 * BUTTON_TOP_GAP)];
    [_hugButton setImage:[UIImage imageNamed:@"heart-64.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_hugButton];
}

- (void)redrawButtonUser{
    if (checkAnd) {
        NSMutableArray *arrBtn = [NSMutableArray new];
        for (UIButton *btnLast in self.contentView.subviews) {
            [arrBtn addObject:btnLast];
        }
        UIButton *btn1;
        UIButton *btn2;
        if (arrBtn.count>1) {
            btn1 = [arrBtn objectAtIndex:arrBtn.count -2];
            btn2 = [arrBtn objectAtIndex:arrBtn.count -1];
            CGRect fBtn2 = [btn2 frame];
            fBtn2.size.width = CGRectGetWidth(btn2.frame)+15;
            btn2.frame = fBtn2;
            [self renameButtonWithTag:btn1.tag];
            NSString *currentTitle = [btn2.titleLabel text];
                [btn2 setTitle:[NSString stringWithFormat:@"and  %@",[currentTitle substringToIndex:currentTitle.length]] forState:UIControlStateNormal];
        }
    }
}

- (void)renameButtonWithTag :(int)tag{
    for (UIButton *btn in self.contentView.subviews) {
        NSString *currentTitle = [btn.titleLabel text];
        if (btn.tag == tag) {
            [btn setTitle:[currentTitle substringToIndex:currentTitle.length-1] forState:UIControlStateNormal];
            break;
        }
    }
}

-(void)didClickMoreUser:(id)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(didTouchMoreHugUserButton:)]) {
        [_delegate performSelector:@selector(didTouchMoreHugUserButton:) withObject:sender];
    }
}

- (void)didClickUser:(id)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(didTouchUserButton:)]) {
        [_delegate performSelector:@selector(didTouchUserButton:) withObject:sender];
    }
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

+ (CGFloat)cellHeight
{
    return CELL_HEIGHT + 5;
}
@end
