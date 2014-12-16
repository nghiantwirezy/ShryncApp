//
//  RevealMenuViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 11/19/13.
//  Copyright (c) 2013 stackbear. All rights reserved.
//

#import "RevealMenuViewController.h"
#import "AppDelegate.h"
#import "UserSession.h"
#import "PPRevealSideViewController.h"
#import "PageCellData.h"
#import "ContainedWebViewController.h"
#import "HowDoYouFeelViewController.h"
#import "ProfileViewController.h"
#import "MyFeelingsViewController.h"
#import "CenterCircleImageView.h"
#import "TextTherapiesViewController.h"
#import "AudioPlayerViewController.h"
#import "ATConnect.h"
#import "MBProgressHUD.h"
#import "ReferralFinder.h"
#import "PublicFeelingsViewController.h"
#import "SettingsViewController.h"
#import "PublicProfileViewController.h"
#import "InviteFriendsViewController.h"
#import "DetailCommentsViewController.h"

#define PAGE_CELL_KEY @"PageCell"

#define HOW_DO_YOU_FEEL_TEXT @"How I Feel"
#define MY_THERAPY_TEXT @"My Therapy"
#define MY_AUDIO_THERAPY_TEXT @"My Audio Therapy"
#define MY_AUDIO_THERAPY_DOWNLOAD_TEXT @"My Audio Therapy Downloads"
#define MY_TEXT_THERAPY_TEXT @"My Text Therapy"
#define MY_THERAPIST_REFERRALS_TEXT @"My Nearby Therapists"
#define MY_FEELINGS_TEXT @"My Feelings"
#define PUBLIC_FEELINGS_TEXT @"All Feelings"
#define MY_PROFILE_TEXT @"My Profile"
#define SETTINGS_TEXT @"Settings"
#define PUBIC_PROFILE_TEXT @"Public Profile"
#define SIGNIN_TEXT @" Sign In "
#define SIGNOUT_TEXT @" Sign Out "
#define FIND_FRIENDS_TEXT @"Find Friends"
#define DETAILS_COMMENT @"Details Comment"

@interface RevealMenuViewController ()

@end

@implementation RevealMenuViewController {
    NSArray *_pageCellDataArray;
    UITableViewCell *_lastCell;
    MBProgressHUD *_hud;
}

- (void)feedbackButtonAction
{
    ATConnect *connection = [ATConnect sharedConnection];
    [connection presentMessageCenterFromViewController:self];
}

- (void)privacyButtonAction
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.privacyTextView;
    [viewController presentFromController:self];
}

- (void)termButtonAction
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.termTextView;
    [viewController presentFromController:self];
}

- (void)aboutButtonAction
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    ContainedWebViewController *viewController = delegate.aboutTextView;
    [viewController presentFromController:self];
}

- (void)signoutButtonAction
{
    UserSession *userSession = [UserSession currentSession];
    if ([userSession isGuestSession]) {
        [UserSession signOut];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate navigateToLandingPage];
    }else if([UserSession currentSession]){
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Shrync Sign Out!"
                                                               message:@"Are you sure you want to sign out? "
                                                              delegate:self
                                                     cancelButtonTitle:@"No"
                                                     otherButtonTitles:@"Yes",nil];
        [messageAlert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index = %ld",buttonIndex);
    if (buttonIndex == 1)
    {
        [UserSession signOut];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate navigateToLandingPage];
    }
    else if(buttonIndex == 0)
    {
        NSLog(@"You have clicked NO");
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pageCellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row < _pageCellDataArray.count - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:PAGE_CELL_KEY];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PAGE_CELL_KEY];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            backgroundView.backgroundColor = [UIColor colorWithRed:42.0 / 255 green:45.0 / 255 blue:50.0 / 255 alpha:1];
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, 230, 1)];
            separatorView.backgroundColor = [UIColor colorWithRed:59.0 / 255 green:61.0 / 255 blue:66.0 / 255 alpha:1];
            [backgroundView addSubview:separatorView];
            
            cell.backgroundView = backgroundView;
            cell.textLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    } else {
        cell = _lastCell;
    }
    
    PageCellData *pageCellData = [_pageCellDataArray objectAtIndex:indexPath.row];
    [pageCellData formatCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _pageCellDataArray.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PageCellData *pageCellData = [_pageCellDataArray objectAtIndex:indexPath.row];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        if (pageCellData.page != nil) {
            if (pageCellData.page == delegate.howDoYouFeelViewController) {
                HowDoYouFeelViewController *controller = delegate.howDoYouFeelViewController;
                [controller resetButtonAction];
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
                NSLog(@"My 1");
            } else if (pageCellData.page == delegate.profileViewController) {
                ProfileViewController *controller = delegate.profileViewController;
                [controller resetEditStates];
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
                NSLog(@"My Profile");
                
            }else  if (pageCellData.page == delegate.myFeelingsViewController) {
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
            }else if (pageCellData.page == delegate.textTherapiesViewController) {
                TextTherapiesViewController *controller = delegate.textTherapiesViewController;
                FeelingRecord *feelingRecord = [[UserSession currentSession].latestFeelingRecords objectAtIndex:0];
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
                [controller setFeelingRecord:feelingRecord];
                NSLog(@"My 3");
            } else if (pageCellData.page == delegate.audioPlayerViewController) {
                AudioPlayerViewController *controller = delegate.audioPlayerViewController;
                FeelingRecord *feelingRecord = [[UserSession currentSession].latestFeelingRecords objectAtIndex:0];
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
                [controller setFeelingRecord:feelingRecord];
                NSLog(@"My 4");
            } else if (pageCellData.page == delegate.publicFeelingsViewController) {
                if ([delegate.navigationController.viewControllers objectAtIndex:0] != pageCellData.page) {
                    [delegate.publicFeelingsViewController setRefreshOnce:YES];
                }
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:pageCellData.page] animated:YES];
            }
            
            if ([pageCellData.page isKindOfClass:[SettingsViewController class]]){
                SettingsViewController *controller = delegate.settingsViewController;
                [controller resetEditStates];
                
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:[delegate.navigationController topViewController]] animated:YES];
                [[[delegate.navigationController topViewController] navigationController] pushViewController:controller animated:YES];
            }
            
            if ([pageCellData.page isKindOfClass:[InviteFriendsViewController class]]){
                InviteFriendsViewController *controller = delegate.inviteFriendsViewController;
                //[controller resetEditStates];
                
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:[delegate.navigationController topViewController]] animated:YES];
                [[[delegate.navigationController topViewController] navigationController] pushViewController:controller animated:YES];
            }
            
            if ([pageCellData.page isKindOfClass:[DetailCommentsViewController class]]){
                DetailCommentsViewController *controller = [DetailCommentsViewController new];
                
                [delegate.navigationController setViewControllers:[NSArray arrayWithObject:[delegate.navigationController topViewController]] animated:YES];
                [[[delegate.navigationController topViewController] navigationController] pushViewController:controller animated:YES];
            }
            
            if (pageCellData.page == delegate.profileViewController) {
                [delegate.profileViewController resetNavigationLeftItems];
            }
            [delegate.revealSideViewController popViewControllerAnimated:YES];
        }else if (indexPath.row == 5) {
            ReferralFinder *finder = delegate.referralFinder;
            [finder beginInViewController:self withHUD:_hud];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        PageCellData *howDoYouFeelData = [[PageCellData alloc] initWithImageName:@"reveal menu how do you feel icon.png" text:NSLocalizedString(HOW_DO_YOU_FEEL_TEXT, nil) page:delegate.howDoYouFeelViewController];
        PageCellData *myAudioTherapyData = [[PageCellData alloc] initWithImageName:@"reveal menu my audio therapy icon.png" text:NSLocalizedString(MY_AUDIO_THERAPY_TEXT, nil) page:delegate.audioPlayerViewController];

        PageCellData *myTextTherapyData = [[PageCellData alloc] initWithImageName:@"reveal menu my text therapy icon.png" text:NSLocalizedString(MY_TEXT_THERAPY_TEXT, nil) page:delegate.textTherapiesViewController];
        PageCellData *myTherapistReferralsData = [[PageCellData alloc] initWithImageName:@"reveal menu my therapist referrals icon.png" text:NSLocalizedString(MY_THERAPIST_REFERRALS_TEXT, nil) page:nil];
        PageCellData *myFeelingsData = [[PageCellData alloc] initWithImageName:@"reveal menu my feelings icon.png" text:NSLocalizedString(MY_FEELINGS_TEXT, nil) page:delegate.myFeelingsViewController];
        PageCellData *publicFeelingData = [[PageCellData alloc] initWithImageName:@"reveal menu all feelings icon.png" text:NSLocalizedString(PUBLIC_FEELINGS_TEXT, nil) page:delegate.publicFeelingsViewController];
        PageCellData *myProfileData = [[PageCellData alloc] initWithImageName:@"reveal menu my profile icon.png" text:NSLocalizedString(MY_PROFILE_TEXT, nil) page:delegate.profileViewController];
        
        delegate.settingsViewController = [[SettingsViewController alloc]init];
        PageCellData *settingsData = [[PageCellData alloc] initWithImageName:@"reveal at setting icon.png" text:NSLocalizedString(SETTINGS_TEXT, nil) page:delegate.settingsViewController];
        
        delegate.inviteFriendsViewController = [[InviteFriendsViewController alloc]init];
        PageCellData *followData = [[PageCellData alloc] initWithImageName:@"reveal menu follow icon.png" text:NSLocalizedString(FIND_FRIENDS_TEXT, nil) page:delegate.inviteFriendsViewController];
        
        _pageCellDataArray = [NSArray arrayWithObjects:publicFeelingData, howDoYouFeelData, myFeelingsData, myAudioTherapyData, myTextTherapyData, myTherapistReferralsData, myProfileData, followData,settingsData, nil];
        _lastCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _lastCell.backgroundColor = [UIColor colorWithRed:42.0 / 255 green:45.0 / 255 blue:50.0 / 255 alpha:1];
        _lastCell.textLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
        _lastCell.textLabel.textColor = [UIColor whiteColor];
        _lastCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        _nameLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
        _nameSubLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:13.0f];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.privacyButton.titleLabel.font = self.termButton.titleLabel.font = self.aboutButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
    self.feedbackButton.titleLabel.font = self.signoutButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:15.0f];
    
    self.avatarImageView.buttonAction = ^() {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        ProfileViewController *controller = delegate.profileViewController;
        [controller resetEditStates];
        
        [delegate.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:YES];
        [controller resetNavigationLeftItems];
        
        [delegate.revealSideViewController popViewControllerAnimated:YES];
    };
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:13.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserSession *userSession = [UserSession currentSession];
    self.nameSubLabel.text = userSession.username;
    self.avatarImageView.image = userSession.userAvatar;
    
    if ([userSession isGuestSession]) {
        [_signoutButton setTitle:NSLocalizedString(SIGNIN_TEXT, nil) forState:UIControlStateNormal];
    }else if([UserSession currentSession]){
        [_signoutButton setTitle:NSLocalizedString(SIGNOUT_TEXT, nil) forState:UIControlStateNormal];
    }
    
    UITableViewCell *audioCell = [self tableView:self.sideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *textCell = [self tableView:self.sideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (userSession.latestFeelingRecords.count > 0) {
        audioCell.selectionStyle = textCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        audioCell.selectionStyle = textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
