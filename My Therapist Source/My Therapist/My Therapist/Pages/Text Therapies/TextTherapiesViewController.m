//
//  TextTherapiesViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 6/28/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "TextTherapiesViewController.h"
#import "FeelingRecord.h"
#import "Feeling.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserSession.h"
#import "TextPage.h"

#define ICON_EDGE 12
#define ICON_GAP 6

#define TITLE @"MY TEXT THERAPY"

#define MEDIA_URL @"https://secure.shrync.com/api/feelings/media"
#define TOKEN_PARAM_KEY @"token"
#define TYPE_PARAM_KEY @"type"
#define MAIN_FEELING_INDEX_KEY @"mainfeelingindex"
#define PAGE_SIZE_KEY @"count"
#define MEDIA_URL_KEY @"media"

@interface TextTherapiesViewController ()

@end

@implementation TextTherapiesViewController {
  FeelingRecord *_feelingRecord;
  UIBarButtonItem *_backButtonItem;
  
  NSMutableArray *_pages;
  
  UIView *_webViewContainerView;
  NSInteger _previousPage;
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFeelingRecord:(FeelingRecord *)feelingRecord
{
  if (feelingRecord == _feelingRecord) {
    return;
  }
  
  _feelingRecord = feelingRecord;
  _previousPage = 0;
  
  if (self.view == nil) {
    return;
  }
  
  for (TextPage *page in _pages) {
    [page.iconView removeFromSuperview];
  }
  [_webViewContainerView removeFromSuperview];
  
  NSMutableString *mainFeelingIndexes = [NSMutableString stringWithFormat:@"%d", ((Feeling *)[self.feelingRecord.feelings objectAtIndex:0]).mainFeelingIndex];
  for (int i = 1; i < self.feelingRecord.feelings.count; ++i) {
    Feeling *feeling = [self.feelingRecord.feelings objectAtIndex:i];
    [mainFeelingIndexes appendFormat:@",%d", feeling.mainFeelingIndex];
  }
  
  NSDictionary *parameters = @{TOKEN_PARAM_KEY: [UserSession currentSession].sessionToken, TYPE_PARAM_KEY: @"0", MAIN_FEELING_INDEX_KEY: mainFeelingIndexes, PAGE_SIZE_KEY: @99};
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"%@",parameters);
  [manager GET:MEDIA_URL parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSMutableDictionary *feelingByIndex = [[NSMutableDictionary alloc] init];
         for (Feeling *feeling in self.feelingRecord.feelings) {
           [feelingByIndex setObject:feeling forKey:[NSNumber numberWithUnsignedInteger:feeling.mainFeelingIndex]];
         }
         
         NSArray *results = responseObject;
         results = [results sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
           NSString *i1 = [a objectForKey:MAIN_FEELING_INDEX_KEY];
           NSString *i2 = [b objectForKey:MAIN_FEELING_INDEX_KEY];
           NSInteger n1 = i1.integerValue;
           NSInteger n2 = i2.integerValue;
           
           if (n1 == n2) {
             return NSOrderedSame;
           } else if (n1 < n2) {
             return NSOrderedAscending;
           } else {
             return NSOrderedDescending;
           }
         }];
         
         int pageCount = results.count;
         _webViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * pageCount, _textTherapyScrollView.bounds.size.height)];
         CGFloat x = ([UIScreen mainScreen].bounds.size.width - ICON_EDGE * pageCount - ICON_GAP * (pageCount - 1)) / 2;
         CGFloat y = (_feelingsIconContainerView.bounds.size.height - ICON_EDGE) / 2;
         
         [_pages removeAllObjects];
         
         for (int i =  0; i < results.count; ++i) {
           NSDictionary *dict = [results objectAtIndex:i];
           NSString *mainFeelingIndex = [dict objectForKey:MAIN_FEELING_INDEX_KEY];
           NSString *url = [dict objectForKey:MEDIA_URL_KEY];
             if ([url isEqual:[NSNull null]]) {
                 continue;
             }
           Feeling *feeling = [feelingByIndex objectForKey:[NSNumber numberWithInteger:mainFeelingIndex.integerValue]];
           
           NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5];
           UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(_textPagingContainerView.bounds.size.width * i, 0, _textPagingContainerView.bounds.size.width, _textPagingContainerView.bounds.size.height)];
           [webView loadRequest:request];
           
           UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, ICON_EDGE, ICON_EDGE)];
           imageView.contentMode = UIViewContentModeScaleAspectFit;
           imageView.image = i == 0 ? feeling.feelingActiveIcon : feeling.feelingInactiveIcon;
           
           TextPage *page = [[TextPage alloc] init];
           page.feeling = feeling;
           page.webView = webView;
           page.iconView = imageView;
           [_pages addObject:page];
           
           [_feelingsIconContainerView addSubview:imageView];
           [_webViewContainerView addSubview:webView];
           
           x += (ICON_EDGE + ICON_GAP);
         }
         
         [_textTherapyScrollView addSubview:_webViewContainerView];
         [_textTherapyScrollView setContentOffset:CGPointZero];
         _textTherapyScrollView.contentSize = CGSizeMake(_webViewContainerView.bounds.size.width, 1);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
       }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat pageWidth = scrollView.frame.size.width;
  float fractionalPage = scrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  if (_previousPage != page) {
    for (int i = 0; i < _pages.count; ++i) {
      TextPage *textPage = [_pages objectAtIndex:i];
      
      UIImageView *imageView = textPage.iconView;
      Feeling *feeling = textPage.feeling;
      UIWebView *webView = textPage.webView;
      
      [webView.scrollView setContentOffset:CGPointZero];
      
      if (i == page) {
        imageView.image = feeling.feelingActiveIcon;
      } else {
        imageView.image = feeling.feelingInactiveIcon;
      }
    }
    _previousPage = page;
  }
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
  
  _pages = [[NSMutableArray alloc] init];
  [self setFeelingRecord:_feelingRecord];
}

- (void)viewDidLayoutSubviews
{
  for (TextPage *page in _pages) {
    CGRect frame = page.webView.frame;
    frame.size.height = _textPagingContainerView.bounds.size.height;
    page.webView.frame = frame;
  }
  
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  if (self.navigationController.viewControllers.count > 1) {
    self.navigationItem.leftBarButtonItem = _backButtonItem;
  } else {
    self.navigationItem.leftBarButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
