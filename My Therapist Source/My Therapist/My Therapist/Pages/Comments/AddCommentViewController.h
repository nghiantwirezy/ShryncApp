//
//  AddCommentViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 12/2/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManagement.h"

@class FeelingRecord, UIPlaceHolderTextView;

@interface AddCommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    CLLocation *currentLocation;
}
@property (nonatomic, assign) CLLocationCoordinate2D currenLocations;
@property (readonly, nonatomic) FeelingRecord *feelingRecord;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint, *selectedPictureViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *activitySelectionButton, *selectPictureButton, *deletePictureButton;

@property (weak, nonatomic) IBOutlet UILabel *saveButtonLabel, *cancelButtonLabel, *shareFeelingLabel, *activityLabel, *activityOptionalLabel, *activitySelectionLabel, *commentLabel, *commentOptionalLabel, *commentLengthLabel, *attachPictureLabel, *attachPictureOptionalLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView, *commentViewContainer, *innerContainerView, *selectedPictureContainerView;
@property (weak, nonatomic) IBOutlet UISwitch *shareFeelingSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *mapPublicSwitch;
- (IBAction)mapPublicSwitchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mapPublicLabel;
@property (strong, nonatomic) LocationManagement *locationManagement;

- (void)setFeelings:(NSArray *)feelings;
- (void)setActivityIndex:(NSUInteger)index;

- (IBAction)activitySelectionButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)selectPictureButtonPressed;
- (IBAction)deletePictureButtonPressed;
- (IBAction)shareFeelingSwitchAction:(id)sender;
-(void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status;
@end
