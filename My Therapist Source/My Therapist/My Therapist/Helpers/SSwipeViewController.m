//
//  SSwipeViewController.m
//  My Therapist
//
//  Created by Bùi Văn Huy on 9/4/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "SSwipeViewController.h"

@interface SSwipeViewController ()

@end

@implementation SSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizers];
    // Do any additional setup after loading the view.
}

- (void)handlePan:(UISwipeGestureRecognizer *)object{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [app showRevealMenu];
}


- (void)addGestureRecognizers {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    //add the your gestureRecognizer , where to detect the touch..
    [self.view addGestureRecognizer:rightRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
