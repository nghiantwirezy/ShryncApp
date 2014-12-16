//
//  TextViewController.h
//  My Therapist
//
//  Created by Yexiong Feng on 1/20/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainedWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setUrl:(NSString *)url title:(NSString *)title;
- (void)setHtmlFileName:(NSString *)name title:(NSString *)title;
- (void)presentFromController:(UIViewController *)controller;

@end
