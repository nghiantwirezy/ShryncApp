//
//  TextViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 1/20/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "ContainedWebViewController.h"

@interface ContainedWebViewController ()

@end

@implementation ContainedWebViewController {
  NSString *_fileName;
  NSString *_fileContent;
  NSString *_title;
  
  NSURL *_url;
  
  UINavigationItem *_barItem;
  UIViewController *_presentingController;
  UILabel *_titleLabel;
}

- (void)presentFromController:(UIViewController *)controller
{
  _presentingController = controller;
  [_presentingController presentViewController:self animated:YES completion:nil];
}

- (void)dismiss
{
  [_presentingController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUrl:(NSString *)url title:(NSString *)title
{
  _url = [NSURL URLWithString:url];
  _title = title;
}

- (void)setHtmlFileName:(NSString *)name title:(NSString *)title
{
  if ([name isEqualToString:_fileName]) {
    return;
  }
  
  _fileName = name;
  _title = title;
  _fileContent = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_fileName ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
  if (_fileName && inType == UIWebViewNavigationTypeLinkClicked) {
    [[UIApplication sharedApplication] openURL:[inRequest URL]];
    return NO;
  }
  
  return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
  UINavigationItem *item = [[UINavigationItem alloc] init];
  item.rightBarButtonItem = rightButton;
  item.hidesBackButton = YES;
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
  titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
  titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  item.titleView = titleLabel;
  
  _titleLabel = titleLabel;
  _barItem = item;
  [_myNavigationBar pushNavigationItem:_barItem animated:NO];
  
  if (_fileName) {
    [_webView loadHTMLString:[_fileContent description] baseURL:nil];
  }
  _titleLabel.text = _title;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  _titleLabel.text = _title;
  
  if (_url) {
    NSURLRequest* request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [_webView loadRequest:request];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  if (_url) {
    [_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
