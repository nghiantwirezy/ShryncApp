//
//  MoreHugsUserViewController.h
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreHugsUserViewCell.h"
#import "BaseModel.h"

@class FeelingRecord;
@interface MoreHugsUserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_arrayMe;
    BaseModel *_baseModel;
}

@property (weak, nonatomic) IBOutlet UIView *hugsUserContentView;
@property (weak, nonatomic) IBOutlet UITableView *hugsUserContentTableView;
@property (weak, nonatomic) IBOutlet UIButton *dismissViewButton;
@property (strong, nonatomic) NSMutableArray *arrayListFollowingMe;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (nonatomic, retain) NSArray *arrayMoreUsers;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;

- (IBAction)dismissViewButtonAction:(id)sender;
- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord;
-(void)compareListFollowing;
@end
