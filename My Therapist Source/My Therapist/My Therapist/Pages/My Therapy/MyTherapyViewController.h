//
//  MyTherapyViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/25/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailMapView.h"
#import <CoreLocation/CoreLocation.h>
#import "BaseModel.h"
#import "UserProfileView.h"

@class FeelingRecord, MyFeelingsViewController,FeelingRecordLoader, PublicProfileViewController;

@interface MyTherapyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UserProfileViewDelegate>{
    IBOutlet MKMapView *_mapView;
    MKMapView *_mapViews;

    NSString *_tittle;
    NSString *_subtitle;
    NSMutableArray *_feelingRecords;
    CLPlacemark *placemark;
    BaseModel *_baseModel;
    UserProfileView *_userProfileView;
}

@property (nonatomic, retain) NSDictionary *dicParamPublic;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userId;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerContainerBottomOffsetConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapContainerHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContainerHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentContainerHeightConstraint, *attachmentLabelHeightConstraint, *shortcutContainerHeightConstraint, *deleteContainerHeightConstraint, *shareContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholderView;
@property (weak, nonatomic) IBOutlet UILabel *mapPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (nonatomic, assign) CLLocationCoordinate2D currenLocations;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButtonView;
- (IBAction)mapButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteCheckinButton;

@property (weak, nonatomic) IBOutlet UILabel *audioTherapyLabel, *audioTherapySubtitleLabel, *audioTherapyDownloadLabel, *audioTherapyDownloadSubtitleLabel, *referralLabel, *referralSubtitleLabel, *textTherapyLabel, *textTherapySubtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *attachmentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *attachmentContentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;

@property (weak, nonatomic) IBOutlet UILabel *shareFeelingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *shareFeelingSwitch;

// New
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTotalInnerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFeelingTableViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightFeelingTableViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMapsViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAttachmentViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightShareSwithViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightDeleteCheckinViewContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightShortcutContainerConstraint;
@property (assign, nonatomic) CGFloat heightProfileView;
@property (weak, nonatomic) IBOutlet UIView *feelingSummaryInnerView;


- (IBAction)audioTherapyPressed:(id)sender;
- (IBAction)audioTherapyDownloadPressed:(id)sender;
- (IBAction)referralPressed:(id)sender;
- (IBAction)textTherapyPressed:(id)sender;
- (IBAction)attachmentFullscreenButtonPressed;
- (IBAction)deleteButtonPressed;
- (IBAction)shareFeelingSwitchPressed;
- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord;
@property(nonatomic, retain)  MKMapView *mapView;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *subtitle;

@property (weak, nonatomic) IBOutlet UIView *audioShortcutSubView;
@property (weak, nonatomic) IBOutlet UIButton *audioTherapyButton;
@property (weak, nonatomic) IBOutlet UIButton *textTherapyButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyTherapyButton;
@property (weak, nonatomic) IBOutlet UIView *shortcutContainerView;
@property (weak, nonatomic) IBOutlet UIView *shareSwitchContainerView;
@property (weak, nonatomic) IBOutlet UIView *deleteContainerView;


@end
