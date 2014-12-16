//
//  AttachmentFullscreenViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 3/29/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "AttachmentFullscreenViewController.h"
#import "MBProgressHUD.h"
#import "UserSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "ImageAttachmentCell.h"
#import "AppDelegate.h"
#import "FeelingRecord.h"
#import "PublicProfileViewController.h"

#define TITLE @"ATTACHED PICTURE"

#define FULLSIZE_URL @"https://secure.shrync.com/api/feelings/fullsize"
#define TOKEN_PARAM_KEY @"token"
#define CODE_PARAM_KEY @"feeling"

#define LOADING_TEXT @"Loading..."

@interface AttachmentFullscreenViewController ()<ImageDelegate>

@end

@implementation AttachmentFullscreenViewController {
  UIBarButtonItem *_backButtonItem;
  UIImage *_image;
  
  MBProgressHUD *_hud;
  NSCache *_imageCache;
  FeelingRecord *_feelingRecord;
  AFHTTPRequestOperation *_operation;
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  UIImage *backImage = [UIImage imageNamed:@"back button.png"];
  UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
  [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
  _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
  titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
  titleLabel.text = NSLocalizedString(TITLE, nil);
  titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  self.navigationItem.titleView = titleLabel;
  
  _hud = [[MBProgressHUD alloc] initWithView:self.view];
  _hud.labelFont = [UIFont fontWithName:@"BebasNeue" size:13.0];
  _hud.labelText = NSLocalizedString(LOADING_TEXT, nil);
  [self.view addSubview:_hud];
  
  _imageCache = [[NSCache alloc] init];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  self.navigationItem.leftBarButtonItem = _backButtonItem;

    NSDictionary *parameters = @{TOKEN_PARAM_KEY: [UserSession currentSession].sessionToken, CODE_PARAM_KEY: _attachFeelingCode};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [_hud show:YES];
    
    _operation = [manager GET:FULLSIZE_URL parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [_imageCache setObject:responseObject forKey:_attachFeelingCode];
                        self.imageView.image = responseObject;
                        
                        [_hud hide:YES afterDelay:0.3];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@", error);
                        
                        [_hud hide:YES afterDelay:0.3];
                      }];
}

#pragma mark - Image Delegate

- (void)clickedButtonImage:(NSIndexPath *)indexPath{

    AttachmentFullscreenViewController *controllerr = [AttachmentFullscreenViewController new];
    if (_feelingRecord.attachedPicture) {
        [controllerr setImage:_feelingRecord.attachedPicture];
        [controllerr setFeelingRecordTherapy:_feelingRecord];
    } else if (_feelingRecord.code) {
        [controllerr setFeelingCode:_feelingRecord.code];
    }
    [self.navigationController pushViewController:controllerr animated:YES];
}



- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [_operation cancel];
  [_hud hide:YES];
}


- (void)setFeelingRecordTherapy:(FeelingRecord *)feelingRecord{
    _feelingRecord = feelingRecord;
}

@end
